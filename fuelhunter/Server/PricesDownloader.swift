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
import FHClient
import GRPC
import NIO
import MapKit
import CoreLocation


protocol PricesDownloaderLogic: class {
	static func isAllowedToDownload() -> Bool
	static func shouldInitiateDownloadWhenPossible() -> Bool
	static func updateLastDownloadTime()
	static func resetLastDownloadTime()
	static func lastDownloadTimeStamp() -> Double
	static func removeAllPricesAndCallDownloader()
	func work(completionHandler: @escaping () -> Void)
}

class PricesDownloader: PricesDownloaderLogic {

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
		if ScenesManager.shared.getAppSceneState().rawValue <= AppSceneState.introPageGPSAccessAsking.rawValue {
			return false
		}

		// This case is when we have gps location but not yet user location. Can take up to a second.
		if(AppSettingsWorker.shared.getGPSIsEnabled() && AppSettingsWorker.shared.userLocation == nil) {
			print("gps enabled but no user location yet")
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

//		print("lastDownloadTimestamp \(lastDownloadTimestamp)");
//		print("Date().timeIntervalSince1970 \(Date().timeIntervalSince1970)");

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

	class func shouldInitiateDownloadWhenPossible() -> Bool {

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

//		print("lastDownloadTimestamp \(lastDownloadTimestamp)");
//		print("Date().timeIntervalSince1970 \(Date().timeIntervalSince1970)");

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
//
//			let companyList = [
//				"Circle K",
//				"Neste",
//				"Virši",
//				"Viada",
//				"Latijas Nafta",
//				"Latvijas Nafta",
//				"Astarte",
//				"Dinaz",
//				"Metro",
//				"Gotika",
//				"Gotika Auto",
//				"LPG",
//				"MC",
//				"Geksans",
//				"Intergaz",
//				"Kool",
//				"Rietumu Nafta",
//				"Straujupīte",
//				"Kings",
//				"Ingrid-A",
//				"VTU Valmiera",
//				"Virāža A"
//			]


			if AppSettingsWorker.shared.userLocation != nil {
				print("AppSettingsWorker.shared.userLocation Location is available!!");

				print("closest city name \(CityWorker.getClosestCityName())")

			} else {
				print("AppSettingsWorker.shared.userLocation Location is not available!!");
			}


/*
			let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
			let channel = ClientConnection
				.insecure(group: group)
				.connect(host: "162.243.16.251", port: 50051)
			let client = SnapshotServiceClient(channel: channel)
			let query = SnapshotQuery.with { _ in }
			
			let task = {
				print("about to do the connection!!");
				do {
					let response = try client.getSnapshots(query)
						.response
						.wait()


					print("after response wait!!");

					let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()
					//--- Delete old prices
					let fetchRequest: NSFetchRequest<PriceEntity> = PriceEntity.fetchRequest()
					let oldPrices = try backgroundContext.fetch(fetchRequest)
					for oldPrice in oldPrices {
						backgroundContext.delete(oldPrice)
					}
					//=== Delete old prices

					var count = 0

					var pricesDict: [String: [PriceEntity]] = [:]

					var dict: [String: PriceEntity] = [:]

					var combinedAddresses: [String: [PriceEntity]] = [:]

					let filteredResults = response.snapshots.filter({
							!$0.name.contains("Nivels DUS")
						&& !$0.name.contains("Saldus Priede DUS")
						&& !$0.name.contains("SOS Group")
						&& !$0.name.contains("Žiguli")
						&& !$0.name.contains("Lauksalaca")
						&& !$0.name.contains("Sezams")
						&& !$0.name.contains("AP Deals")
						&& !$0.name.contains("Pūķis")
						&& !$0.name.contains("Euro Gas")
						&& !$0.name.contains("Galvers")
						&& !$0.name.contains("Avots 95")
						&& !$0.name.contains("DUS AR gāze")
						&& !$0.name.contains("AR gāze DUS")
						&& !$0.name.contains("EURO GAS GUS")
						&& !$0.name.contains("Gāze+ GUS")
						&& !$0.name.contains("DUS Madliena 2")
						&& !$0.name.contains("Euro Gas GUS")
						&& !$0.name.contains("ES Gāze GUS Mārupe")
						&& !$0.name.contains("SMPC Salaspils DUS")
						&& !$0.name.contains("Dim Vol Barkava DUS")
						&& !$0.name.contains("Oktāns")
						&& !$0.name.contains("PS Gāze Sigulda")
						&& !$0.name.contains("Lateva")
						&& !$0.name.contains("VDI Ceļmalas DUS")
						&& !$0.name.contains("JK DUS")
						&& !$0.name.contains("Varpa DUS")
						&& !$0.name.contains("ICO DUS")
						&& !$0.name.contains("Šleins")
						&& !$0.name.contains("Devals DUS")
						&& !$0.name.contains("Talsu autotransports DUS")
						&& !$0.name.contains("Kurzemes sēklas DUS")
						&& !$0.name.contains("SERVISS BETTA GUS")
						&& !$0.name.contains("Opus Wood DUS")

						&& !$0.type.contains("Neste Pro Diesel")
						&& !$0.type.contains("D miles PLUS")
					})

					for price in filteredResults {

						var priceName = price.name

						if(price.name.contains("LPG")) {
							priceName = price.name.replacingOccurrences(of: "LPG", with: "Latvijas Propāna Gāze")
						}

						count += 1

						var fuelType = ""

						if(price.type == "lpg" || price.type == "gas") { fuelType = "fuel_gas" }
						if(price.type == "Neste Futura D" || price.type == "diesel" || price.type == "D miles") { fuelType = "fuel_dd" }
						if(price.type == "Neste Futura 95" || price.type == "95" || price.type == "95 miles") { fuelType = "fuel_95" }
						if(price.type == "Neste Futura 98" || price.type == "98" || price.type == "98 miles PLUS") { fuelType = "fuel_98" }

						if(fuelType.isEmpty) {
							print("unsupported price type \(price.type)")
							continue
						}


						//--- Address
						let addressFetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

						addressFetchRequest.predicate = NSPredicate(format: "stationName == %@", price.name)
						var address = try backgroundContext.fetch(addressFetchRequest)

						var priority = false

						let possibleCompanyNames = companyList.filter({ priceName.contains($0) })
						var possibleCompanyName = ""
						if !possibleCompanyNames.isEmpty {
							possibleCompanyName = possibleCompanyNames.first!
							if(possibleCompanyName == "Gotika") { possibleCompanyName = "Gotika Auto" }
							if(possibleCompanyName == "Latijas Nafta") { possibleCompanyName = "Latvijas Nafta" }
						}


						if address.isEmpty {
							// Try 2 - priority

//							print("Mapped: \(priceName) TO: \(possibleCompanyName)")

							let addressFetchRequest2: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
							addressFetchRequest2.predicate = NSPredicate(format: "companyName == %@ && name2 CONTAINS[cd] %@", possibleCompanyName, price.address, price.address, price.address)
							address = try backgroundContext.fetch(addressFetchRequest2)

							if !address.isEmpty {
								priority = true
							}
						}


						if address.isEmpty {
							// Try 3
							let possibleCompanyNames = companyList.filter({ priceName.contains($0) })
								if !possibleCompanyNames.isEmpty {
									var possibleCompanyName = possibleCompanyNames.first!

									if(possibleCompanyName == "Gotika") { possibleCompanyName = "Gotika Auto" }
									if(possibleCompanyName == "Latijas Nafta") { possibleCompanyName = "Latvijas Nafta" }

									let addressFetchRequest2: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
									addressFetchRequest2.predicate = NSPredicate(format: "companyName == %@ && (name CONTAINS[cd] %@ || shortName CONTAINS[cd] %@)", possibleCompanyName, price.address, price.address, price.address)
									address = try backgroundContext.fetch(addressFetchRequest2)
								}

						}

						if address.isEmpty {

							print("Did not find address for company \(price)")
						} else {

							var addressObj = address.first!

							// LN AND LPG have 1 similar address.
							for add in address {
								if add.companyName == possibleCompanyName {
									addressObj = add
									break
								}
							}


							if(address.first!.enteredDebug == false) {
								print("enteredDebug NAME: \(price.name) ADDRESS: \(price.address) CITY: \(price.city)")
							}
							

							if let userLocation = AppSettingsWorker.shared.userLocation {
								addressObj.distance = Int64(Int(userLocation.distance(from: CLLocation.init(latitude: addressObj.latitude, longitude: addressObj.longitude))))
								if(addressObj.distance > 10000) {
									// Too far. Skip
									continue;
								}
							}



							/* Let through if
								new price priority == true, and stored priority == false
								new priority == true and stored priority == true and price is lower
							*/
							// Filter out to show only cheapest prices
							if let storedPrice = pricesDict["\(address.first!.companyName!)-\(fuelType)"] {
								if storedPrice.first!.managedObjectContext != nil {
									if(priority == true && storedPrice.first!.priority == false) {
										// Let through
									} else if (priority == true && storedPrice.first!.priority == true && Double(storedPrice.first!.price!)! >= Double("\(price.price)")!) {
										// Let through
									} else if (priority == false && storedPrice.first!.priority == false && Double(storedPrice.first!.price!)! >= Double("\(price.price)")!) {
										// Let through
									} else {
										continue;
									}
								}
							}


							// Check if we already saved a price for this fuelType-address and new price is lower or same
							if let storedPrice = dict["\(fuelType)-\(address.first!.name!)"] {
								if storedPrice.managedObjectContext != nil {
									if(priority == true && storedPrice.priority == false) {
										// Let through
									} else if (priority == true && storedPrice.priority == true && Double(storedPrice.price!)! >= Double("\(price.price)")!) {
										// Let through
									} else if (priority == false && storedPrice.priority == false && Double(storedPrice.price!)! >= Double("\(price.price)")!) {
										// Let through
									} else {
										continue;
									}
								}
							}


							// we always create a new one, because old are destroyed
							let priceObject = PriceEntity.init(context: backgroundContext)

							priceObject.priority = priority

							//--- Company
							let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

							companyFetchRequest.predicate = NSPredicate(format: "name == %@", address.first!.companyName!)
							let company = try backgroundContext.fetch(companyFetchRequest)


							if company.isEmpty {
								let companyObject = CompanyEntity.init(context: backgroundContext)
								companyObject.name = address.first!.companyName!
								companyObject.isHidden = false
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

							tempAddresses.insert(address.first!)
							addressDescription.append("\(address.first!.name!), ")
							addressDescription = String(addressDescription.dropLast().dropLast())

							priceObject.addresses = tempAddresses as NSSet
							//===


							priceObject.addressDescription = addressDescription
							priceObject.price = "\(price.price)"
							if(priceObject.price!.count == 4) {
								priceObject.price = "\(price.price)0"
							}
							priceObject.fuelType = fuelType
							priceObject.city = "\(price.city)"
							priceObject.id = "\(count)"
							priceObject.fuelSortId = Int16(FuelType.init(rawValue: fuelType)?.index ?? 0)
							priceObject.isCheapest = false



							if AppSettingsWorker.shared.getGPSIsEnabled() == false && priceObject.city != "Rīga" {
								backgroundContext.delete(priceObject)
							} else
							{
								var array: [PriceEntity] = []

								if let oldStoredPriceArray = pricesDict["\(address.first!.companyName!)-\(fuelType)"] {
									if oldStoredPriceArray.first?.managedObjectContext == nil || oldStoredPriceArray.first!.price! != priceObject.price {
										for aP in oldStoredPriceArray {
											backgroundContext.delete(aP)
										}
									} else {
										array.append(contentsOf: oldStoredPriceArray)
									}
								}
								array.append(priceObject)
								pricesDict["\(address.first!.companyName!)-\(fuelType)"] = array






								if let oldStoredPriceObj = dict["\(fuelType)-\(address.first!.name!)"] {
									backgroundContext.delete(oldStoredPriceObj)
								}
								dict["\(fuelType)-\(address.first!.name!)"] = priceObject



								if var stored = combinedAddresses["\(address.first!.companyName!)-\(price.price)"] {
									stored.append(priceObject)
									combinedAddresses["\(address.first!.companyName!)-\(price.price)"] = stored
								} else {
									combinedAddresses["\(address.first!.companyName!)-\(price.price)"] = [priceObject]
								}
							}
						}
						//===
					}


					/* TODO
					All prices, need to be sorted by distance - close->far
					And then filter out companies. if price found within 5 km, then use that price, instead further away.
					*/


					for (_, pricesArray) in combinedAddresses {
						if pricesArray.count > 1 {
							var addresses = Set<AddressEntity>()
							var editablePricesArray = pricesArray
							var updatablePrice: PriceEntity?

							var index = 0
							var count = 0
							for price in editablePricesArray {
								count += 1
								if(price.managedObjectContext == nil) {
									continue;
								}
								if updatablePrice == nil {
									updatablePrice = price
									index = count - 1
								}

								if let paddr = price.addresses {
									if !paddr.allObjects.isEmpty {
										if let obj = paddr.allObjects as? [AddressEntity] {
											if let firstObj = obj.first as? AddressEntity {
												addresses.insert(firstObj)
											}
										}
									}
								}
							}

							if let letPriceToBeUpdated = updatablePrice {

								editablePricesArray.remove(at: index)

								var addressDescription = ""
								var currentCity = ""

								for addr in addresses {
									if(currentCity != addr.city!) {
										currentCity = addr.city!
										addressDescription.append("\(currentCity) - ")
									}
									addressDescription.append("\(addr.name!), ")
								}

								addressDescription = String(addressDescription.dropLast().dropLast())
								letPriceToBeUpdated.addressDescription = addressDescription

								letPriceToBeUpdated.addresses = addresses as NSSet
								for price in editablePricesArray {
									backgroundContext.delete(price)
								}
							}
						}
					}

					DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)

					print("filteredResults.count \(filteredResults.count)")
					print("response.snapshots.count \(response.snapshots.count)")

				} catch {
					print("caught: \(error)")
		//			fatalError()
				}

				DispatchQueue.main.async {
					// when background job finished, do something in main thread
					PricesDownloader.updateLastDownloadTime()
					DataDownloader.shared.downloaderIsActive = false
					PricesDownloader.lastDownloadResult = .success
					completionHandler()
				}
			}

			DataBaseManager.shared.addATask(action: task)

*/


			var pricesDict: [String: [PriceEntity]] = [:]
			var priorityPricesDict: [String: PriceEntity] = [:]

			var distancesDict: [String: [String: PriceEntity]] = [:]

			var combinedAddresses: [String: [PriceEntity]] = [:]


			let sessionConfig = URLSessionConfiguration.default
			sessionConfig.timeoutIntervalForRequest = 10.0
			sessionConfig.timeoutIntervalForResource = 60.0
			let session = URLSession(configuration: sessionConfig)

			// All fuel types: https://robertdemodemo.wixsite.com/mysite/_functions/example/prices?type_1=diesel&type_2=95&type_3=98&type_4=lpg"

			let attachmentArray = [
				"type_1=",
				"&type_2=",
				"&type_3=",
				"&type_4="
			]

			var count = 0

			var string = "https://robertdemodemo.wixsite.com/mysite/_functions/example/prices?"

			let fuelTypes = AppSettingsWorker.shared.getFuelTypeToggleStatus()

			if fuelTypes.typeDD {
				string = string + attachmentArray[count] + "fuel_dd"
				count += 1
			}

			if fuelTypes.type95 {
				string = string + attachmentArray[count] + "fuel_95"
				count += 1
			}

			if fuelTypes.type98 {
				string = string + attachmentArray[count] + "fuel_98"
				count += 1
			}

			if fuelTypes.typeGas {
				string = string + attachmentArray[count] + "fuel_gas"
			}

			print("string \(string)")

			print("PRICESDOWNLOADER startPrices \(Date().description(with: Locale.current))")

			session.dataTask(with: URL(string: string)!) { (data, response, error) -> Void in
				// Check if data was received successfully
				
				if error == nil && data != nil {

					UserDefaults.standard.set(data, forKey: "lastDownloadedPricesData")
					UserDefaults.standard.synchronize()

//					let sha = NSDataToSha256String.sha256(data: data!)

//					if sha == self.getPreviousSHA() {
//						print("same old prices data!")
//						PricesDownloader.updateLastDownloadTime()
//						PricesDownloader.lastDownloadResult = .success
//						DispatchQueue.main.asyncAfter(deadline: .now()) {
//							DataDownloader.shared.downloaderIsActive = false
//						}
//						completionHandler()
//						return
//					} else {
//						print("new prices data!")
//					}


					/*

					1.) Filter out by distance. Leave only closest
					2.) Combine, filter by company-type.
					Now we have, for example,  Neste Lubānas 64 1.24 (waze)   Neste Lubānas 64  1.25 (Neste)
					3.) Need to leave lowest price only  OR leave Neste price only.
					4.) If multiple addresses with remaining price - combine.

					*/
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

							print("PRICESDOWNLOADER prices downloaded \(Date().description(with: Locale.current))")

							let decodedResults = try JSONDecoder().decode(PriceRequestCodable.self, from: data!)



							let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()

							//--- Delete old prices
							let fetchRequest: NSFetchRequest<PriceEntity> = PriceEntity.fetchRequest()

							let oldPrices = try backgroundContext.fetch(fetchRequest)

							for oldPrice in oldPrices {
								backgroundContext.delete(oldPrice)
							}
							//=== Delete old prices


							var shouldShowMultiplePricesFromSameCompany = false

							let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
//
							companyFetchRequest.predicate = NSPredicate(format: "isEnabled == YES")
							let existingCompanyList = try backgroundContext.fetch(companyFetchRequest)
//
							if existingCompanyList.count <= 1 {
								shouldShowMultiplePricesFromSameCompany = true
							}


							//--- create new prices, company and addresses

							print("decodedResults.prices \(decodedResults.prices.count)")
							/*
							LPG Berģi == Latvijas Nafta. LPG jāpatur gāze, un  pārējais ir priekš LN un otrādi.?
							*/


							for price in decodedResults.prices {

								//--- Address
								// First try to get based on stationId.
								let addressFetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

								addressFetchRequest.predicate = NSPredicate(format: "id == %@", "\(price.stationId)")
								let address = try backgroundContext.fetch(addressFetchRequest)


								if address.isEmpty {
									print("Did not find address for company \(price).")
								} else {

									let addressObj = address.first!

									if(address.count > 1) {
										print("Be warned, there are found multiple addresses for this price! \(address)")
									}

									if let userLocation = AppSettingsWorker.shared.userLocation {
										addressObj.distance = Int64(Int(userLocation.distance(from: CLLocation.init(latitude: addressObj.latitude, longitude: addressObj.longitude))))
										if(addressObj.distance > 9000) {
											// Too far. Skip
											continue;
										}
									}



									/*
										Neste-type_dd
										Circle K-type_dd
										...

										Let through if
										// origin == Neste
										// origin != Neste && newPrice < storedPrice
									*/


									if shouldShowMultiplePricesFromSameCompany == false {
										// Filter out to show only cheapest prices
										if let storedPrice = pricesDict["\(addressObj.companyName!)-\(price.type)"] {
											let firstStoredPrice = storedPrice.first!
											if firstStoredPrice.managedObjectContext != nil {

												if price.priority {
													// Neste always priority
												} else if !price.priority && !firstStoredPrice.priority && Float(price.price)! < Float(firstStoredPrice.price!)! {
													// Low price always priority (because all prices will be a day old anyways.)

													// But if we already had stored homepage price, then.. we can't.
												} else {
													continue;
												}
											}
										}
									}

									// we always create a new one, because old are destroyed
									let priceObject = PriceEntity.init(context: backgroundContext)

									priceObject.priority = price.priority


									//--- Company
									let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

									companyFetchRequest.predicate = NSPredicate(format: "name == %@", addressObj.companyName!)
									let company = try backgroundContext.fetch(companyFetchRequest)


									if company.isEmpty {
										print("Did not find company with name \(addressObj.companyName!)")

										let companyObject = CompanyEntity.init(context: backgroundContext)
										companyObject.name = address.first!.companyName!
										companyObject.isHidden = false
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
//									var addressDescription = "Price priority: \(priceObject.priority) \(price.city) - "
									var addressDescription = "\(price.city) - "

									tempAddresses.insert(addressObj)
									addressDescription.append("\(addressObj.address!), ")
									addressDescription = String(addressDescription.dropLast().dropLast())

									priceObject.addresses = tempAddresses as NSSet
									//===


									priceObject.addressDescription = addressDescription
									priceObject.price = "\(price.price)"
									if(priceObject.price!.count == 4) {
										priceObject.price = "\(price.price)0"
									}
									priceObject.fuelType = price.type
									priceObject.city = "\(price.city)"
									priceObject.id = "\(price.id)"
									priceObject.fuelSortId = Int16(FuelType.init(rawValue: price.type)?.index ?? 0)

									priceObject.date = price.date
									addressObj.date = price.date
									addressObj.notEntered = false

									if AppSettingsWorker.shared.getGPSIsEnabled() == false && priceObject.city != "Rīga" {
										backgroundContext.delete(priceObject)
									} else {

										if shouldShowMultiplePricesFromSameCompany == false {
											var array: [PriceEntity] = []
											if let oldStoredPriceArray = pricesDict["\(address.first!.companyName!)-\(price.type)"] {
												if oldStoredPriceArray.first?.managedObjectContext == nil
													|| oldStoredPriceArray.first!.price! != priceObject.price!
													 {
													for aP in oldStoredPriceArray {
														backgroundContext.delete(aP)
													}
												} else {
													array.append(contentsOf: oldStoredPriceArray)
												}
											}
											array.append(priceObject)
											pricesDict["\(address.first!.companyName!)-\(price.type)"] = array
										} else {

											if let oldStoredPrice = priorityPricesDict["\(addressObj.address!)-\(price.type)"] {
												if oldStoredPrice.managedObjectContext == nil
													|| (oldStoredPrice.priority == false && priceObject.priority == true)
												 {
													backgroundContext.delete(oldStoredPrice)
													priorityPricesDict["\(addressObj.address!)-\(price.type)"] = priceObject
												} else if(oldStoredPrice.priority == true && priceObject.priority == true) {
													print("This should not happen. We have two priority prices for same location/type")
												} else if(oldStoredPrice.priority == true && priceObject.priority == false) {
													backgroundContext.delete(priceObject)
												}
											} else {
												priorityPricesDict["\(addressObj.address!)-\(price.type)"] = priceObject
											}
										}





										var subDistancesDict: [String: PriceEntity] = [:]

										if let storedPriceDistancesArray = distancesDict["\(addressObj.companyName!)-\(price.type)"] {
											subDistancesDict = storedPriceDistancesArray
										}
										subDistancesDict["\(addressObj.distance)"] = priceObject

										distancesDict["\(addressObj.companyName!)-\(price.type)"] = subDistancesDict


										if var stored = combinedAddresses["\(address.first!.companyName!)-\(price.type)-\(price.price)"] {
											stored.append(priceObject)
											combinedAddresses["\(address.first!.companyName!)-\(price.type)-\(price.price)"] = stored
										} else {
											combinedAddresses["\(address.first!.companyName!)-\(price.type)-\(price.price)"] = [priceObject]
										}
									}
								}
							}

							/* TODO
							All prices, need to be sorted by distance - close->far
							And then filter out companies. if price found within 5 km, then use that price, instead further away.
							*/


							for (_, pricesDict) in distancesDict {

								let sortedByDistanceTypeArray = pricesDict.keys.sorted(by: {$0.localizedStandardCompare($1) == .orderedAscending})

								var count = 0
								for distance in sortedByDistanceTypeArray {
//									legit
									let price: PriceEntity = pricesDict["\(distance)"]!

									if(price.managedObjectContext == nil) {
										continue;
									}


									if(count > 1 && Int(distance)! > 6000) {
										backgroundContext.delete(price)
//										print("deleting.. too far \(distance)")
									}

									count += 1
								}
							}


							for (_, pricesArray) in combinedAddresses {
								var oldestDate: Double = 0

								if pricesArray.count > 1 {
									var addresses = Set<AddressEntity>()
									var editablePricesArray = pricesArray
									var updatablePrice: PriceEntity?

									var index = 0
									var count = 0
									for price in editablePricesArray {
										count += 1
										if(price.managedObjectContext == nil || price.isDeleted == true) {
											continue;
										}

//										print("distance \((price.addresses!.allObjects.first! as! AddressEntity).distance) - price \(price.price!) \(price.fuelType!) \(price.companyMetaData!.company!.name!) - \((price.addresses!.allObjects.first! as! AddressEntity).name ?? "nil address")  -- \(price.isDeleted)")


										if updatablePrice == nil {
											updatablePrice = price
											index = count - 1
										}

										if oldestDate == 0 || oldestDate > price.date {
											oldestDate = price.date
										}

										if let paddr = price.addresses {
											if !paddr.allObjects.isEmpty {
												if let obj = paddr.allObjects as? [AddressEntity] {
													if let firstObj = obj.first {
														addresses.insert(firstObj)
													}
												}
											}
										}
									}

									if let updatablePrice = updatablePrice {

										updatablePrice.date = oldestDate
										editablePricesArray.remove(at: index)

//										var addressDescription = "Price priority: \(letPriceToBeUpdated.priority) | "
										var addressDescription = ""
										var currentCity = ""

										for addr in addresses {
											if(currentCity != addr.city!) {
												currentCity = addr.city!
												addressDescription.append("\(currentCity) - ")
											}
											addressDescription.append("\(addr.address!), ")
										}

										addressDescription = String(addressDescription.dropLast().dropLast())
										updatablePrice.addressDescription = addressDescription

										updatablePrice.addresses = addresses as NSSet
										for price in editablePricesArray {
											backgroundContext.delete(price)
										}
									}
								}

							}

							if shouldShowMultiplePricesFromSameCompany == true {
								let closeAddressFetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

								let sort = NSSortDescriptor(key: "distance", ascending: true)
								closeAddressFetchRequest.sortDescriptors = [sort]
								closeAddressFetchRequest.predicate = NSPredicate(format: "distance <= %i && prices.@count == 0", 8000)

								let allCloseAddresses = try backgroundContext.fetch(closeAddressFetchRequest)

								var counter = 5000

								for address in allCloseAddresses {
									counter += 1

									print("allCloseAddresses count \(allCloseAddresses.count)")

									let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()

									companyFetchRequest.predicate = NSPredicate(format: "name == %@", address.companyName!)
									let company = try backgroundContext.fetch(companyFetchRequest)

									if !company.isEmpty {
										let priceObject = PriceEntity.init(context: backgroundContext)
										priceObject.notEntered = true
										var tempAddresses = Set<AddressEntity>()
										tempAddresses.insert(address)
										priceObject.addresses = tempAddresses as NSSet
										priceObject.addressDescription = "\(address.city!) - \(address.address!)"
										priceObject.companyMetaData = company.first!.companyMetaData
										priceObject.price = "0"
										priceObject.city = address.city!
										priceObject.date = Date.init().timeIntervalSince1970
										priceObject.id = "\(counter)"
										priceObject.fuelType = "fuel_dd"
										priceObject.priority = false
										priceObject.fuelSortId = Int16(counter)

										address.notEntered = true
									}
								}
							}

							// Important to do this before, because afterwards it can no longer call update for core data
							if(decodedResults.prices.count == 0) {
								PricesDownloader.resetLastDownloadTime()
								PricesDownloader.lastDownloadResult = .success
							} else {
								PricesDownloader.updateLastDownloadTime()
								PricesDownloader.lastDownloadResult = .success
							}


							print("PRICESDOWNLOADER prices just parsed \(Date().description(with: Locale.current))")

							DataBaseManager.shared.saveBackgroundContext(backgroundContext: backgroundContext)
//							self.setSHA(sha: sha)

							print("PRICESDOWNLOADER prices prices just saved \(Date().description(with: Locale.current))")
							print("Prices - Sucess downloading and parsing!.")



						} catch let error {
							// Something went wrong
							print("Prices - Something went wrong. Reseting. \(error)")
							Crashlytics.crashlytics().record(error: error)

//							Analytics.logEvent("downloading - prices", parameters: ["Error": "error \(error.localizedDescription)"])
							PricesDownloader.resetLastDownloadTime()
							PricesDownloader.lastDownloadResult = .parsingError
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
