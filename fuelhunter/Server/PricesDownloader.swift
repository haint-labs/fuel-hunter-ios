//
//  PricesDownloader.swift
//  fuelhunter
//
//  Created by Guntis on 09/02/2020.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import Firebase
import UIKit

class PricesDownloader: NSObject {

	static var downloadingState: DownloaderState {
		if DataDownloader.shared.downloaderIsActive {
			return .downloading
		}

		if lastDownloadResult == .none && PricesDownloader.isAllowedToDownload() {
			return .downloading
		}
		else
		{
			switch lastDownloadResult {
				case .none:
					return .downloaded
				case .success:
					return .downloaded
				case .timeout:
					return .timeout
				case .serverError:
					return .serverError
				case .parsingError:
					return
						.parsingError
			}
		}
	}

	static var lastDownloadResult: DownloaderLastResult = .none

	private func getPreviousSHA() -> String {
		return UserDefaults.standard.string(forKey: "PricesSHA") ?? ""
	}

	private func setSHA(sha: String) {
		UserDefaults.standard.set(sha, forKey: "PricesSHA")
		UserDefaults.standard.synchronize()
	}



	class func isAllowedToDownload() -> Bool {
//		return true

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

	class func updateLastDownloadTime() {
		UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "PricesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}

	class func resetLastDownloadTime() {
		UserDefaults.standard.set(0, forKey: "PricesDownloaderLastDownloadTimestamp")
		UserDefaults.standard.synchronize()
	}

	class func lastDownloadTimeStamp() -> Double {
		UserDefaults.standard.double(forKey: "PricesDownloaderLastDownloadTimestamp")
	}


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
	func work(completionHandler: @escaping () -> Void) {

		if !PricesDownloader.isAllowedToDownload() {
			completionHandler()
			return
		}

		if DataDownloader.shared.downloaderIsActive {
			completionHandler()
			return
		}

		DataDownloader.shared.downloaderIsActive = true

		DispatchQueue.background(background: {
			// do something in background

			let sessionConfig = URLSessionConfiguration.default
			sessionConfig.timeoutIntervalForRequest = 10.0
			sessionConfig.timeoutIntervalForResource = 60.0
			let session = URLSession(configuration: sessionConfig)

			var string = ""

			if UserDefaults.standard.integer(forKey: "priceTesting") == 1
			{
				string = "http://www.mocky.io/v2/5e7c62be3500006800068b27"

				UserDefaults.standard.set(2, forKey: "priceTesting")
				UserDefaults.standard.synchronize()
			}
			else if UserDefaults.standard.integer(forKey: "priceTesting") == 2
			{
				string = "http://www.mocky.io/v2/5e7c62703500007d00068b16"

				UserDefaults.standard.set(3, forKey: "priceTesting")
				UserDefaults.standard.synchronize()
			}

			else
			{
				string = "http://www.mocky.io/v2/5e7c61d5350000e005068b00"

				UserDefaults.standard.set(1, forKey: "priceTesting")
				UserDefaults.standard.synchronize()
			}

			session.dataTask(with: URL(string: string)!) { (data, response, error) -> Void in
				// Check if data was received successfully
				
				if error == nil && data != nil {
					let sha = NSDataToSha256String.sha256(data: data!)

					if sha == self.getPreviousSHA() {
						print("same old prices data!")
						PricesDownloader.updateLastDownloadTime()
						PricesDownloader.lastDownloadResult = .success
						completionHandler()
						return
					} else {
						print("new prices data!")
					}
					
					let group = DispatchGroup()

					print("Prices - Just downloaded data!");

					let task = {
						print("Prices - About to do prices data!!");
						do {
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
//									oldPrice.setPrimitiveValue(nil, forKey: "company")
//									oldPrice.company = nil
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
									companyObject.isEnabled = false

									let companyMetaDataObject = CompanyMetaDataEntity.init(context: backgroundContext)
									companyMetaDataObject.company = companyObject

									priceObject.companyMetaData = companyMetaDataObject
								} else {
									priceObject.companyMetaData = company.first!.companyMetaData
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
										addressObject.distanceInMeters = -1
										addressObject.estimatedTimeInMinutes = -1
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
								priceObject.id = price.id
								priceObject.fuelSortId = Int16(FuelType.init(rawValue: price.fuelType)?.index ?? 0)
								priceObject.isCheapest = price.isCheapest
							}

							DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)
							self.setSHA(sha: sha)
							
							print("Prices - Sucess downloading and parsing!.")
							PricesDownloader.updateLastDownloadTime()
						} catch let error {
							// Something went wrong
							print("Prices - Something went wrong. Reseting. \(error)")
							Analytics.logEvent("downloading", parameters: ["Error": "error \(error.localizedDescription)"])
							PricesDownloader.resetLastDownloadTime()
						}

						print("prices - status was called! Main thread = \(Thread.current.isMainThread) ");
						print("group \(group)")
						group.leave()
					}


					group.enter()

					DataBaseManager.shared.addATask(action: task)

					print("prices - about to wait!")

					group.wait()

					print("Prices FINALIZEE!!!!!")


				} else {
					print("Received error OR no data. \(error ?? "" as! Error)")
					PricesDownloader.resetLastDownloadTime()

					if let httpResponse = response as? HTTPURLResponse {
						print("httpResponse.statusCode \(httpResponse.statusCode)")

						if httpResponse.statusCode == 408
							|| httpResponse.statusCode == 504
							|| httpResponse.statusCode == 598
							|| httpResponse.statusCode == 524
							|| httpResponse.statusCode == 460
						{
							PricesDownloader.lastDownloadResult = .timeout
						} else {
							PricesDownloader.lastDownloadResult = .serverError
						}
					}
					else
					{
						PricesDownloader.lastDownloadResult = .serverError
					}
				}

				DispatchQueue.main.async {
					// when background job finished, do something in main thread
					DataDownloader.shared.downloaderIsActive = false

					completionHandler()

				}

			}.resume()

		}, completion:{

		})
	}

	class func removeAllPricesAndCallDownloader() {
		let task = {

			let context = DataBaseManager.shared.mainManagedObjectContext()

			let fetchRequest: NSFetchRequest<PriceEntity> = PriceEntity.fetchRequest()

			if let oldPrices = try? context.fetch(fetchRequest) {
				for oldPrice in oldPrices {
					context.delete(oldPrice)
				}
			}

			DataBaseManager.shared.saveContext()

			PricesDownloader.resetLastDownloadTime()

			DataDownloader.shared.activateProcess()
		}

		DataBaseManager.shared.addATask(action: task)
	}
}
