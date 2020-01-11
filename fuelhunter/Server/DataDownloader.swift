//
//  DataDownloader.swift
//  fuelhunter
//
//  Created by Guntis on 28/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import CommonCrypto
import CoreData
import UIKit

class DataDownloader: NSObject {

	static let shared = DataDownloader()

	public var downloaderIsActive: Bool = false

	// MARK: Private functions

	private func getPreviousPricesSHA() -> String {
		return UserDefaults.standard.string(forKey: "PricesSHA") ?? ""
	}

	private func setPricesSHA(sha: String) {
		UserDefaults.standard.set(sha, forKey: "PricesSHA")
		UserDefaults.standard.synchronize()
	}


	private func getPreviousCompaniesSHA() -> String {
		return UserDefaults.standard.string(forKey: "CompaniesSHA") ?? ""
	}

	private func setCompaniesSHA(sha: String) {
		UserDefaults.standard.set(sha, forKey: "CompaniesSHA")
		UserDefaults.standard.synchronize()
	}


	func isAllowedToDownloadPrices() -> Bool {
		return true

		// if scene is not past fuel type choosing - not allowed yet.
		if ScenesManager.shared.getAppSceneState().rawValue <= AppSceneState.introPageChooseFuelType.rawValue {
			return false
		}

		let lastDownloadTimestamp = UserDefaults.standard.double(forKey: "PricesDownloaderLastDownloadTimestamp")

		// on first time it probably will be 0
		if lastDownloadTimestamp == 0 {
			return true
		}

		// if it is older than 12 hours
		if lastDownloadTimestamp + 60 * 60 * 12 <= Date().timeIntervalSince1970 {
			// TODO: Send notif, to lock UI for changes.
			return true
		}

		// if it is older than 1 hour
		if lastDownloadTimestamp + 60 * 60 <= Date().timeIntervalSince1970 {
			return true
		}

		// if only up to 59 minutes passed..

		let storedDate = Date.init(timeIntervalSince1970: lastDownloadTimestamp)
		let calendar = Calendar.current
		let componentsFromStoredDate = calendar.dateComponents([.hour], from: storedDate)
		let componentsFromNow = calendar.dateComponents([.hour], from: Date())

		// if it is different hour (like, if we synced 15:49 and now it is 16:00, then it should refresh)
		if componentsFromStoredDate.hour != componentsFromNow.hour {
			return true
		}

		return false
	}

	func updateLastDownloadPricesTime() {
		UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "PricesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}

	func resetLastDownloadPricesTime() {
		UserDefaults.standard.set(0, forKey: "PricesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}


	func isAllowedToDownloadCompanies() -> Bool {
		return true

		let lastDownloadTimestamp = UserDefaults.standard.double(forKey: "CompaniesDownloaderLastDownloadTimestamp")

		// on first time it probably will be 0
		if lastDownloadTimestamp == 0 {
			return true
		}

		// if it is older than 24 hours
		if lastDownloadTimestamp + 60 * 60 * 24 <= Date().timeIntervalSince1970 {
			// TODO: Send notif, to lock UI for changes.
			return true
		}

		return false
	}

	func updateLastDownloadCompaniesTime() {
		UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "CompaniesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}

	func resetLastDownloadCompaniesTime() {
		UserDefaults.standard.set(0, forKey: "CompaniesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}


	// MARK: Functions

	/*
		Actually download and store data.

		0.) Someone should call this every minute (to try..) , and forced - always when app becomes active.

		1.) First it should check if you can download data ( isAllowedToDownloadPrices() )
		2.) If allowed, download all data. Either all in one request (with 3 separate data arrays), or separate requests
		4.) Downloaded data should have timestamp of last changes. If it is same as before, do nothing.
		5.) If there are changes - remove all db content, store new.
		6.) Send notif that data has been updated (for UI) (if it was showing notif that updating in progress...)
		7.) Update last download time
		7.1.) If error - reset last download time, present inline alert, send notif (for UI)
		8.) If success and gps is enabled, in bg, start fetching directions for each address

		9.) Every time user location changes - need to invalidate all existing stored directions.

	*/
	func downloadPrices() {

		if !isAllowedToDownloadPrices() {
			return
		}

		if downloaderIsActive {
			return
		}

		downloaderIsActive = true

		DispatchQueue.background(background: {
			// do something in background

			URLSession.shared.dataTask(with: URL(string: "http://www.mocky.io/v2/5e0f07613400000d002d7e39")!) { (data, response, error) -> Void in
				// Check if data was received successfully
				if error == nil && data != nil {
					do {
						// Convert to dictionary where keys are of type String, and values are of any type
//						let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//
//						print("json \(json)")
//						print("decodedResults \(String(describing: decodedResults))")

						let sha = self.sha256(data: data!)

						if sha == self.getPreviousPricesSHA() {
							print("same old prices data!")
						} else {
							print("new prices data!")

							/*
								1.) Delete existing price objects
								2.) Create new ones
								3.) Save
							*/
							let decodedResults = try JSONDecoder().decode(PriceRequestCodable.self, from: data!)

							let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()

							//--- Delete old prices
							let fetchRequest: NSFetchRequest<PriceEntity> = PriceEntity.fetchRequest()

							let oldPrices = try backgroundContext.fetch(fetchRequest)

							for oldPrice in oldPrices {
								backgroundContext.delete(oldPrice)
							}
							//=== Delete old prices

							//--- create new prices, company and addresses
							for price in decodedResults.prices {

								// we always create a new one, because old are destroyed
								let priceObject = PriceEntity.init(context: backgroundContext)

								//--- Company
								let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

								fetchRequest.predicate = NSPredicate(format: "name == %@", price.company)
								let company = try backgroundContext.fetch(fetchRequest)


								if company.isEmpty {
									let companyObject = CompanyEntity.init(context: backgroundContext)
									companyObject.name = price.company
									companyObject.isHidden = true
									priceObject.company = companyObject
								} else {
									priceObject.company = company.first
								}
								//===


								//--- Address
								var tempAddresses = Set<AddressEntity>()
								var addressDescription = "\(price.city) - "
								for address in price.addresses {
									let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
									fetchRequest.predicate = NSPredicate(format: "name == %@", address.name)
									let foundAddresses = try backgroundContext.fetch(fetchRequest)

									if foundAddresses.isEmpty {
										let addressObject = AddressEntity.init(context: backgroundContext)
										addressObject.name = address.name
										addressObject.latitude = address.latitude
										addressObject.longitude = address.longitude
										tempAddresses.insert(addressObject)
									} else {
										tempAddresses.insert(foundAddresses.first!)
									}

									addressDescription.append("\(address.name), ")
								}

								addressDescription = String(addressDescription.dropLast().dropLast())

								// If no addresses, for some reason, then we can't show this price. Delete it.
								if tempAddresses.isEmpty {
									backgroundContext.delete(priceObject)
									continue
								} else {
									priceObject.addresses = tempAddresses as NSSet
								}
								//===

								priceObject.addressDescription = addressDescription
								priceObject.price = price.price
								priceObject.fuelType = price.fuelType
								priceObject.city = price.city
							}

							DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)
							self.setPricesSHA(sha: sha)
						}

						print("Prices - Sucess downloading and parsing!.")
						self.updateLastDownloadPricesTime()
					} catch let error {
						// Something went wrong
						print("Prices - Something went wrong. Reseting. \(error)")
						self.resetLastDownloadPricesTime()
					}
				} else {
					print("Received error OR no data. \(error ?? "" as! Error)")
					self.resetLastDownloadPricesTime()
				}

				DispatchQueue.main.async {
					// when background job finished, do something in main thread
					self.downloaderIsActive = false

					// After prices, we always try companies. This will fail most of the time,
					// but will work perfectly, when it will be possible, making it in sequence.
					self.downloadCompanies()
				}

			}.resume()

		}, completion:{

		})


//		DirectionsWorker.shared.updateDistancesAndDirections()

//		updateLastDownloadTime()

//		resetLastDownloadTime()


	}


	/*
		Proposal for companies..

		Download it once 24 hours, and once you do,
		if there is some change, it could be presented as a pop up..
		Like, new company available? Pop up that you can now choose also "this source".
		Some company went way (which was selected) ?  Pop up that shows it.
	*/
	func downloadCompanies() {

		if !isAllowedToDownloadCompanies() {
			return
		}

		if downloaderIsActive {
			return
		}

		downloaderIsActive = true

		DispatchQueue.background(background: {
			// do something in background

			URLSession.shared.dataTask(with: URL(string: "http://www.mocky.io/v2/5e1199c73100002700593f1c")!) { (data, response, error) -> Void in
				// Check if data was received successfully
				if error == nil && data != nil {
					do {
						// Convert to dictionary where keys are of type String, and values are of any type
//						let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)

//						print("json \(json)")


						/*
							0.) Add (if needed) cheapest
							1.) Disable existing companies
							2.) Update or enable existing companies
							3.) Save
						*/



						let decodedResults = try JSONDecoder().decode(CompanyRequestCodable.self, from: data!)

						let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()

						let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

						//--- Add (if needed) cheapest
						fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", true)
						let companyObjectArray = try backgroundContext.fetch(fetchRequest)
						if companyObjectArray.isEmpty {
							let companyObject = CompanyEntity.init(context: backgroundContext)
							companyObject.isCheapestToggle = true
							companyObject.order = 0
							companyObject.name = "company_type_cheapest_title"
							companyObject.isEnabled = true
							companyObject.isHidden = false
							companyObject.descriptionLV = "Ieslēdzot šo - vienmēr tiks rādīta arī tā kompānija, kurai Latvijā ir lētākā degviela attiecīgajā brīdī"
							companyObject.descriptionEN = "Turning this on - will also show the company, which has the cheapest price at that moment in Latvia"
							companyObject.descriptionRU = "Включение этого параметра всегда будет показывать компанию, у которой в данный момент самое дешевое топливо в Латвии."
						}
						//===


						//--- Disable old companies
						fetchRequest.predicate = NSPredicate(format: "isCheapestToggle == %i", false)

						let oldCompanies = try backgroundContext.fetch(fetchRequest)

						for oldCompany in oldCompanies {
							oldCompany.isHidden = true
						}
						//=== Disable old companies




						let key = UIScreen.main.scale == 3 ? "3x" : "2x"

						//--- Update or enable existing companies
						for company in decodedResults.companies {

							//--- Company

						let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
							fetchRequest.predicate = NSPredicate(format: "name == %@", company.name)
							let companyObjectArray = try backgroundContext.fetch(fetchRequest)

							var companyObject: CompanyEntity!


							if companyObjectArray.isEmpty {
								companyObject = CompanyEntity.init(context: backgroundContext)
								companyObject.name = company.name
							} else {
								companyObject = companyObjectArray.first
							}

							companyObject.isHidden = false
							companyObject.homePage = company.homepage
							companyObject.order = Int16(company.order)
							companyObject.descriptionLV = company.description["lv"]
							companyObject.descriptionRU = company.description["ru"]
							companyObject.descriptionEN = company.description["en"]
							companyObject.logoName = company.logo[key]
							companyObject.largeLogoName = company.largeLogo[key]
							companyObject.mapLogoName = company.mapLogo[key]
							companyObject.mapGrayLogoName = company.mapGrayLogo[key]
							//===
						}

						DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)

//						print("decodedResults \(String(describing: decodedResults))")

						let sha = self.sha256(data: data!)

						if sha == self.getPreviousCompaniesSHA() {
							print("same old companies data!")
						} else {
							print("new companies data!")
							self.setCompaniesSHA(sha: sha)
						}

						print("Sucess downloading and parsing!.")
						self.updateLastDownloadCompaniesTime()
					} catch let error {
						// Something went wrong
						print("Something went wrong. Reseting. \(error)")
						self.resetLastDownloadCompaniesTime()
					}
				} else {
					print("Received error OR no data. \(error ?? "" as! Error)")
					self.resetLastDownloadCompaniesTime()
				}

				DispatchQueue.main.async {
					// when background job finished, do something in main thread
					self.downloaderIsActive = false

					NotificationCenter.default.post(name: .companiesUpdated, object: nil)
				}

			}.resume()

		}, completion:{
		})


//		DirectionsWorker.shared.updateDistancesAndDirections()

//		updateLastDownloadTime()

//		resetLastDownloadTime()
	}


	func sha256(data: Data) -> String {

		var digest = [UInt8](repeating: 0, count:Int(CC_SHA256_DIGEST_LENGTH))

		_ = data.withUnsafeBytes {
			CC_SHA256($0.baseAddress, UInt32(data.count), &digest)
		}

		var sha256String = ""
		/// Unpack each byte in the digest array and add them to the sha256String
		for byte in digest {
			sha256String += String(format:"%02x", UInt8(byte))
		}

		return sha256String
	}

}
