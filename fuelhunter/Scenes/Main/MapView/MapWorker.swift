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

class MapWorker {
	func createUsableDataArray(from data: [FuelList.FetchPrices.ViewModel.DisplayedPrice]) -> [Map.MapData.ViewModel.DisplayedMapPoint] {
		var newArray = [Map.MapData.ViewModel.DisplayedMapPoint]()

		for (_, item) in data.enumerated() {
			for (subIndex, addressItem) in item.address.enumerated() {
				newArray.append(Map.MapData.ViewModel.DisplayedMapPoint(id: item.id, subId: item.id + String(subIndex), companyName: item.companyName, companyBigLogoName: item.companyBigLogoName, companyBigGrayLogoName: item.companyBigGrayLogoName, price: item.price, isPriceCheapest: item.isPriceCheapest, latitude: addressItem.latitude, longitude: addressItem.longitude, addressName: addressItem.name, distanceInKm: 15))
			}
		}

		return newArray
	}
}
