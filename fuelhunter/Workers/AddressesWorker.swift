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


class AddressesWorker: NSObject {

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
//			print("route \(route?.distance), estimated time \(route?.expectedTravelTime) error \(error)")

			if let route = route {
				address.distanceInMeters = Int16(min(10000, route.distance))
				address.estimatedTimeInMinutes = route.expectedTravelTime/60
			} else {
				address.distanceInMeters = -1
				address.estimatedTimeInMinutes = -1
			}


			let task = {
				if let route = route {
					address.distanceInMeters = Int16(min(10000, route.distance))
					address.estimatedTimeInMinutes = route.expectedTravelTime/60
				} else {
					address.distanceInMeters = -1
					address.estimatedTimeInMinutes = -1
				}
			}

			DataBaseManager.shared.addATask(action: task)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {

				completionHandler(address)
			}
		})
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
