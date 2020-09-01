//
//  AddressesWorker.swift
//  fuelhunter
//
//  Created by Guntis on 01/04/2020.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit
import CoreLocation
import FirebaseCrashlytics

import FHClient
import GRPC
import NIO

class AddressesWorker: NSObject {

	private class func getPreviousSHA() -> String {
		return UserDefaults.standard.string(forKey: "AddressSHA") ?? ""
	}

	private class func setSHA(sha: String) {
		UserDefaults.standard.set(sha, forKey: "AddressSHA")
		UserDefaults.standard.synchronize()
	}

	class func sortAllAddresses() {
		if AppSettingsWorker.shared.getGPSIsEnabled() == true {
			if let userLocation = AppSettingsWorker.shared.userLocation {
				let status = {
					let context = DataBaseManager.shared.mainManagedObjectContext()
					
					let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

					do {
						let addresses = try context.fetch(fetchRequest)

						for address in addresses {
//							print("address City name \(address.city!)")
							address.distance = Int64(Int(userLocation.distance(from: CLLocation.init(latitude: address.latitude, longitude: address.longitude))))
						}

						DataBaseManager.shared.saveContext()

					} catch let error {
						print("Something went wrong. \(error) Sentry Report!")
					}
				}

				DataBaseManager.shared.addATask(action: status)
			}
		}
	}


	class func readAllAddressesFromFile() {

		let path = Bundle.main.path(forResource: "stacijas", ofType: "json")
		let data = try! Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)

		let sha = NSDataToSha256String.sha256(data: data)

		if sha == AddressesWorker.getPreviousSHA() {
			print("same old address data!")
			AddressesWorker.sortAllAddresses()
			return
		} else {
			print("new address data!")
			UserDefaults.standard.removeObject(forKey: "savedLocation")
		}

		

		let decodedResults = try! JSONDecoder().decode(AddressRequestCodable.self, from: data)


		let status = {
			let context = DataBaseManager.shared.mainManagedObjectContext()

			let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

			do {
				let oldAddresses = try context.fetch(fetchRequest)

				for oldAddress in oldAddresses {
					context.delete(oldAddress)
				}

				print("oldAddress count \(oldAddresses.count)")

				for address in decodedResults.items {
//					print("address \(address)")
//					let shortAddress = address.address.replacingOccurrences(of: " iela ", with: " ")

					let addressObject = AddressEntity.init(context: context)
					addressObject.id = "\(address.id)"
					addressObject.companyName = address.company
					addressObject.distanceInMeters = -1
					addressObject.estimatedTimeInMinutes = -1
					addressObject.city = address.city
					addressObject.latitude = address.latitude
					addressObject.longitude = address.longitude
					addressObject.address = address.address
//					addressObject.name2 = address.address2
//					addressObject.shortName = shortAddress
					addressObject.stationName = address.name
//					if address.on == 1 {
//						addressObject.enteredDebug = true
//					} else {
//						addressObject.enteredDebug = false
//					}

					if let userLocation = AppSettingsWorker.shared.userLocation {
						addressObject.distance = Int64(Int(userLocation.distance(from: CLLocation.init(latitude: addressObject.latitude, longitude: addressObject.longitude))))
					}
				}


				DataBaseManager.shared.saveContext()
				AddressesWorker.setSHA(sha: sha)

			} catch let error {
				Crashlytics.crashlytics().record(error: error)
				print("Something went wrong. \(error) Sentry Report!")
			}
		}

		DataBaseManager.shared.addATask(action: status)

	}

	class func resetAllAddressesDistances() {
		let task = {
			let context = DataBaseManager.shared.mainManagedObjectContext()
			let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
			
			if let addresses = try? context.fetch(fetchRequest) {
				for address in addresses {
					address.distanceInMeters = -1
					address.estimatedTimeInMinutes = -1
				}
			}

			DataBaseManager.shared.saveContext()
		}

		DataBaseManager.shared.addATask(action: task)
	}


	class func calculateDistance(for address: AddressEntity, completionHandler: @escaping (AddressEntity) -> Void) {

		self.route(to: MKMapItem.init(placemark: MKPlacemark.init(coordinate: CLLocationCoordinate2D.init(latitude: address.latitude, longitude: address.longitude))), completion: { (route, error) in
			if let error = error {
				Crashlytics.crashlytics().record(error: error)
			}
//			print("route \(route?.distance), estimated time \(route?.expectedTravelTime) error \(error)")

			if let route = route {
				address.distanceInMeters = Int32(min(Int32.max, Int32(route.distance)))
				address.estimatedTimeInMinutes = route.expectedTravelTime/60
			} else {
				address.distanceInMeters = -1
				address.estimatedTimeInMinutes = -1
			}

			print("address.distanceInMeters \(address.distanceInMeters)")

			let task = {
				if let route = route {
					address.distanceInMeters = Int32(min(Int32.max, Int32(route.distance)))
					address.estimatedTimeInMinutes = route.expectedTravelTime/60
				} else {
					address.distanceInMeters = -1
					address.estimatedTimeInMinutes = -1
				}

				DataBaseManager.shared.saveContext()
			}

			DataBaseManager.shared.addATask(action: task)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

				completionHandler(address)
			}
		})
	}

	class func debugStuff() {

	return;

		DispatchQueue.background(background: {
			print("doing a background task - start!")


			let group = MultiThreadedEventLoopGroup(numberOfThreads: 5)

			let channel = ClientConnection
				.insecure(group: group)
				.connect(host: "162.243.16.251", port: 50051)

			let client = Fuel_Hunter_FuelHunterServiceClient(channel: channel)

			let companiesFuture = client
				.getCompanies(Fuel_Hunter_Company.Query.with { _ in })
				.response

			companiesFuture
				.whenSuccess {
					print("Companies: \($0.companies.count)")
					print($0.companies)

					let count = $0.companies.count

					DispatchQueue.main.asyncAfter(deadline: .now()) {
						let alert = UIAlertController(title: "Test".localized(), message:"Companies: \(count)" , preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "ok_button_title".localized(), style: .cancel, handler: nil))

						let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController
						(rootVc.viewControllers.first!).present(alert, animated: true)
					}
				}

			let stationFuture = client
				.getStations(Fuel_Hunter_Station.Query.with { _ in })
				.response

			stationFuture
				.whenSuccess {
					print("Stations: \($0.stations.count)")
					print($0.stations)

					let count = $0.stations.count


					DispatchQueue.main.asyncAfter(deadline: .now()) {
						let alert = UIAlertController(title: "Test".localized(), message:"Stations: \(count)" , preferredStyle: .alert)
						alert.addAction(UIAlertAction(title: "ok_button_title".localized(), style: .cancel, handler: nil))

						let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController
						(rootVc.viewControllers.first!).present(alert, animated: true)
					}
					
				}


			let job = companiesFuture
				.and(stationFuture)

			do {
				try _ = job.wait()

			} catch {
				print(error)
				DispatchQueue.main.asyncAfter(deadline: .now()) {

					let alert = UIAlertController(title: "Test".localized(), message:"Error: \(error)" , preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "ok_button_title".localized(), style: .cancel, handler: nil))

					let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController
					(rootVc.viewControllers.first!).present(alert, animated: true)
				}
			}

			


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
//
//			let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
//			let channel = ClientConnection
//				.insecure(group: group)
//				.connect(host: "162.243.16.251", port: 50051)
//			let client = SnapshotServiceClient(channel: channel)
//			let query = SnapshotQuery.with { _ in }
//
//
//			print("GRPC startPrices \(Date().description(with: Locale.current))")
//
//			print("about to do the connection!!");
//			do {
//				let response = try client.getSnapshots(query)
//					.response
//					.wait()
//
//
//				print("------------- |||||||||| ----------- after response wait!!");
//
//				print("GRPC downloaded prices \(Date().description(with: Locale.current))")
//
//				let backgroundContext = DataBaseManager.shared.newBackgroundManagedObjectContext()
//
//				let filteredResults = response.snapshots.filter({
//						!$0.name.contains("Nivels DUS")
//					&& !$0.name.contains("Saldus Priede DUS")
//					&& !$0.name.contains("SOS Group")
//					&& !$0.name.contains("Žiguli")
//					&& !$0.name.contains("Lauksalaca")
//					&& !$0.name.contains("Sezams")
//					&& !$0.name.contains("AP Deals")
//					&& !$0.name.contains("Pūķis")
//					&& !$0.name.contains("Euro Gas")
//					&& !$0.name.contains("Galvers")
//					&& !$0.name.contains("Avots 95")
//					&& !$0.name.contains("DUS AR gāze")
//					&& !$0.name.contains("AR gāze DUS")
//					&& !$0.name.contains("EURO GAS GUS")
//					&& !$0.name.contains("Gāze+ GUS")
//					&& !$0.name.contains("DUS Madliena 2")
//					&& !$0.name.contains("Euro Gas GUS")
//					&& !$0.name.contains("ES Gāze GUS Mārupe")
//					&& !$0.name.contains("SMPC Salaspils DUS")
//					&& !$0.name.contains("Dim Vol Barkava DUS")
//					&& !$0.name.contains("Oktāns")
//					&& !$0.name.contains("PS Gāze Sigulda")
//					&& !$0.name.contains("Lateva")
//					&& !$0.name.contains("VDI Ceļmalas DUS")
//					&& !$0.name.contains("JK DUS")
//					&& !$0.name.contains("Varpa DUS")
//					&& !$0.name.contains("ICO DUS")
//					&& !$0.name.contains("Šleins")
//					&& !$0.name.contains("Devals DUS")
//					&& !$0.name.contains("Talsu autotransports DUS")
//					&& !$0.name.contains("Kurzemes sēklas DUS")
//					&& !$0.name.contains("SERVISS BETTA GUS")
//					&& !$0.name.contains("Opus Wood DUS")
//					&& !$0.name.contains("Gāze Ga Smiltene GUS")
//					&& !$0.name.contains("V.Gaušis un partneri DUS")
//
//					&& !$0.type.contains("Neste Pro Diesel")
//					&& !$0.type.contains("D miles PLUS")
//				})
//
//				for price in filteredResults {
//
////					if(price.name.contains("Circle K")){
////					print(price);
////
////					print("ok");
////					}
//
//					var priceName = price.name
//
//					if(price.name.contains("LPG")) {
//						priceName = price.name.replacingOccurrences(of: "LPG", with: "Latvijas Propāna Gāze")
//					}
//
//					var fuelType = ""
//
//					if(price.type == "lpg" || price.type == "gas") { fuelType = "fuel_gas" }
//					if(price.type == "Neste Futura D" || price.type == "diesel" || price.type == "D miles") { fuelType = "fuel_dd" }
//					if(price.type == "Neste Futura 95" || price.type == "95" || price.type == "95 miles") { fuelType = "fuel_95" }
//					if(price.type == "Neste Futura 98" || price.type == "98" || price.type == "98 miles PLUS") { fuelType = "fuel_98" }
//
//					if(fuelType.isEmpty) {
//						print("unsupported price type \(price.type)")
//						continue
//					}
//
//
//					//--- Address
//					let addressFetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
//
//					addressFetchRequest.predicate = NSPredicate(format: "stationName == %@", price.name)
//					var address = try backgroundContext.fetch(addressFetchRequest)
//
//					let possibleCompanyNames = companyList.filter({ priceName.contains($0) })
//					var possibleCompanyName = ""
//					if !possibleCompanyNames.isEmpty {
//						possibleCompanyName = possibleCompanyNames.first!
//						if(possibleCompanyName == "Gotika") { possibleCompanyName = "Gotika Auto" }
//						if(possibleCompanyName == "Latijas Nafta") { possibleCompanyName = "Latvijas Nafta" }
//					}
//
//
//					if address.isEmpty {
//						// Try 2 - priority
//
////							print("Mapped: \(priceName) TO: \(possibleCompanyName)")
//
//						let addressFetchRequest2: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
//						addressFetchRequest2.predicate = NSPredicate(format: "companyName == %@ && name2 CONTAINS[cd] %@", possibleCompanyName, price.address, price.address, price.address)
//						address = try backgroundContext.fetch(addressFetchRequest2)
//
//					}
//
//
//					if address.isEmpty {
//						// Try 3
//						let possibleCompanyNames = companyList.filter({ priceName.contains($0) })
//							if !possibleCompanyNames.isEmpty {
//								var possibleCompanyName = possibleCompanyNames.first!
//
//								if(possibleCompanyName == "Gotika") { possibleCompanyName = "Gotika Auto" }
//								if(possibleCompanyName == "Latijas Nafta") { possibleCompanyName = "Latvijas Nafta" }
//
//								let addressFetchRequest2: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()
//								addressFetchRequest2.predicate = NSPredicate(format: "companyName == %@ && (name CONTAINS[cd] %@ || shortName CONTAINS[cd] %@ || name2 CONTAINS[cd] %@)", possibleCompanyName, price.address, price.address, price.address, price.address)
//								address = try backgroundContext.fetch(addressFetchRequest2)
//							}
//
//					}
//
//					if address.isEmpty {
//
//						print("Did not find address for company \(price)")
//					} else {
//
//						var addressObj = address.first!
//
//						// LN AND LPG have 1 similar address.
//						for add in address {
//							if add.companyName == possibleCompanyName {
//								addressObj = add
//								break
//							}
//						}
//
//
////						if(addressObj.enteredDebug == false) {
////							print("ORIGINAL_SERVER enteredDebug NAME: \(price.name) ADDRESS: \(price.address) CITY: \(price.city)")
////						}
//
//
//						if let userLocation = AppSettingsWorker.shared.userLocation {
//							addressObj.distance = Int64(Int(userLocation.distance(from: CLLocation.init(latitude: addressObj.latitude, longitude: addressObj.longitude))))
//							if(addressObj.distance > 10000) {
//								// Too far. Skip
//								continue;
//							}
//						}
//
//
//
//						// we always create a new one, because old are destroyed
//						let priceObject = PriceEntity.init(context: backgroundContext)
//
//						//--- Company
//						let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
//
//						companyFetchRequest.predicate = NSPredicate(format: "name == %@", address.first!.companyName!)
//						let company = try backgroundContext.fetch(companyFetchRequest)
//
//
//						if company.isEmpty {
//							let companyObject = CompanyEntity.init(context: backgroundContext)
//							companyObject.name = address.first!.companyName!
//							companyObject.isHidden = false
//							companyObject.isEnabled = false
//
//							let companyMetaDataObject = CompanyMetaDataEntity.init(context: backgroundContext)
//							companyMetaDataObject.company = companyObject
//
//							priceObject.companyMetaData = companyMetaDataObject
//						} else {
//							priceObject.companyMetaData = company.first!.companyMetaData
//						}
//						//===
//
//						//--- Address
//						var tempAddresses = Set<AddressEntity>()
//						var addressDescription = "\(price.city) - "
//
//						tempAddresses.insert(address.first!)
////						addressDescription.append("\(address.first!.name!), ")
//						addressDescription = String(addressDescription.dropLast().dropLast())
//
//						priceObject.addresses = tempAddresses as NSSet
//						//===
//
//
//						priceObject.addressDescription = addressDescription
//						priceObject.price = "\(price.price)"
//						if(priceObject.price!.count == 4) {
//							priceObject.price = "\(price.price)0"
//						}
//						priceObject.fuelType = fuelType
//						priceObject.city = "\(price.city)"
//						priceObject.id = "\(1)"
//						priceObject.fuelSortId = Int16(FuelType.init(rawValue: fuelType)?.index ?? 0)
//
//					}
//					//===
//				}
//
//				print("GRPC finished mapping prices prices \(Date().description(with: Locale.current))")
//
//
//				backgroundContext.reset();
//
//				print("GRPC after context reset \(Date().description(with: Locale.current))")
//
//
//				print("filteredResults.count \(filteredResults.count)")
//				print("response.snapshots.count \(response.snapshots.count)")
//
//			} catch {
//				Crashlytics.crashlytics().record(error: error)
//				print("caught: \(error)")
//	//			fatalError()
//			}


		}, completion:{})

	}

	private class func route(to item: MKMapItem, completion: @escaping (MKRoute?, Error?) -> Void) {
		let request = MKDirections.Request()
		request.source = MKMapItem.forCurrentLocation()
		request.destination = item
		request.transportType = .automobile

		let directions = MKDirections(request: request)
		directions.calculate { response, error in
			completion(response?.routes.first, error)
		}
	}
}
