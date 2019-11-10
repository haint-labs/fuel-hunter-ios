//
//  MapWorker.swift
//  fuelhunter
//
//  Created by Guntis on 12/08/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CoreLocation

class MapWorker {
	func createUsableDataArray(fromPricesArray priceArray: [Price]) -> [Map.MapData.ViewModel.DisplayedMapPoint] {
		var newArray = [Map.MapData.ViewModel.DisplayedMapPoint]()

		let userLocation = AppSettingsWorker.shared.getUserLocation()

		for (_, item) in priceArray.enumerated() {
			for (subIndex, addressItem) in item.address.enumerated() {

				var distanceInMeters: Double = 0


				if(AppSettingsWorker.shared.getGPSIsEnabled() && userLocation != nil) {
					let coordinate = CLLocation(latitude: addressItem.latitude, longitude: addressItem.longitude)
					distanceInMeters = userLocation!.distance(from: coordinate);
				}

				newArray.append(Map.MapData.ViewModel.DisplayedMapPoint(id: item.id, subId: item.id + String(subIndex), company: item.company, price: item.price, isPriceCheapest: item.isPriceCheapest, latitude: addressItem.latitude, longitude: addressItem.longitude, addressName: addressItem.name, addressDescription: item.addressDescription, distanceInMeters: distanceInMeters))
			}
		}

		return newArray
	}
}
