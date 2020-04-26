//
//  CityWorker.swift
//  fuelhunter
//
//  Created by Guntis on 10/04/2020.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit
import MapKit
import CoreLocation


struct City {
	var name: String!
	var location: CLLocation!
	var radius = 1000
}


struct CityAndDistance: Equatable {
	var name: String!
	var distanceInKm: Double!
}


class CityWorker: NSObject {

	static let rigaCity = City.init(name: "Rīga", location: CLLocation.init(latitude: 56.9843062, longitude: 24.1065198), radius: 10000)

	static let cities = [
		City.init(name: "Ainaži", location: CLLocation.init(latitude: 57.855823, longitude: 24.3361918), radius: 2500),
		City.init(name: "Aizkraukle", location: CLLocation.init(latitude: 56.5961625, longitude: 25.2408791), radius: 2500),
		City.init(name: "Aizpute", location: CLLocation.init(latitude: 56.7178887, longitude: 21.6124458), radius: 1500),
		City.init(name: "Aknīste", location: CLLocation.init(latitude: 56.162150, longitude: 25.747750), radius: 1200),
		City.init(name: "Aloja", location: CLLocation.init(latitude: 57.7673383, longitude: 24.8766044), radius: 1100),
		City.init(name: "Alūksne", location: CLLocation.init(latitude: 57.4225747, longitude: 27.0516126), radius: 2500),
		City.init(name: "Ape", location: CLLocation.init(latitude: 57.5392608, longitude: 26.7013836), radius: 1000),
		City.init(name: "Auce", location: CLLocation.init(latitude: 56.4601028, longitude: 22.9049721), radius: 1200),
		City.init(name: "Baldone", location: CLLocation.init(latitude: 56.744593, longitude: 24.4051055), radius: 1500),
		City.init(name: "Baloži", location: CLLocation.init(latitude: 56.8705587, longitude: 24.1354211), radius: 2000),
		City.init(name: "Balvi", location: CLLocation.init(latitude: 57.1329554, longitude: 27.2588112), radius: 2000),
		City.init(name: "Bauska", location: CLLocation.init(latitude: 56.4071791, longitude: 24.2015686), radius: 2000),
		City.init(name: "Brocēni", location: CLLocation.init(latitude: 56.6774709, longitude: 22.5779354), radius: 2400),
		City.init(name: "Cēsis", location: CLLocation.init(latitude: 57.3127059, longitude: 25.2678997), radius: 2500),
		City.init(name: "Cesvaine", location: CLLocation.init(latitude: 56.964383, longitude: 26.3106212), radius: 1500),
		City.init(name: "Dagda", location: CLLocation.init(latitude: 56.0969564, longitude: 27.5336164), radius: 2000),
		City.init(name: "Daugavpils", location: CLLocation.init(latitude: 55.8921947, longitude: 26.5358813), radius: 4500),
		City.init(name: "Dobele", location: CLLocation.init(latitude: 56.6233271, longitude: 23.2843806), radius: 3000),
		City.init(name: "Durbe", location: CLLocation.init(latitude: 56.5860468, longitude: 21.3726593), radius: 950),
		City.init(name: "Grobiņa", location: CLLocation.init(latitude: 56.5368569, longitude: 21.1676042), radius: 2000),
		City.init(name: "Gulbene", location: CLLocation.init(latitude: 57.1740024, longitude: 26.7488536), radius: 2300),
		City.init(name: "Ikšķile", location: CLLocation.init(latitude: 56.8341308, longitude: 24.4978543), radius: 1600),
		City.init(name: "Ilūkste", location: CLLocation.init(latitude: 55.9775916, longitude: 26.3029328), radius: 1500),
		City.init(name: "Jaunjelgava", location: CLLocation.init(latitude: 56.6098615, longitude: 25.0813069), radius: 1100),
		City.init(name: "Jēkabpils", location: CLLocation.init(latitude: 56.4997736, longitude: 25.8717952), radius: 3000),
		City.init(name: "Jelgava", location: CLLocation.init(latitude: 56.6428077, longitude: 23.6998508), radius: 5000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9515772, longitude: 23.6879222), radius: 3000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9568858, longitude: 23.5748316), radius: 3000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9559352, longitude: 23.6262584), radius: 3000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9920398, longitude: 23.8899294), radius: 3000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9763671, longitude: 23.8145326), radius: 3000),
		City.init(name: "Jūrmala", location: CLLocation.init(latitude: 56.9559352, longitude: 23.7600551), radius: 3000),
		City.init(name: "Kandava", location: CLLocation.init(latitude: 57.0334406, longitude: 22.7808082), radius: 2000),
		City.init(name: "Kārsava", location: CLLocation.init(latitude: 56.7849688, longitude: 27.6816234), radius: 1500),
		City.init(name: "Kegums", location: CLLocation.init(latitude: 56.7412424, longitude: 24.7152295), radius: 1600),
		City.init(name: "Krāslava", location: CLLocation.init(latitude: 55.8990778, longitude: 27.1692391), radius: 2000),
		City.init(name: "Kuldīga", location: CLLocation.init(latitude: 56.9669514, longitude: 21.9682056), radius: 3000),
		City.init(name: "Lielvārde", location: CLLocation.init(latitude: 56.7188231, longitude: 24.8120309), radius: 2500),
		City.init(name: "Liepāja", location: CLLocation.init(latitude: 56.5367513, longitude: 20.9825244), radius: 7000),
		City.init(name: "Līgatne", location: CLLocation.init(latitude: 57.236732, longitude: 25.0416299), radius: 1600),
		City.init(name: "Limbaži", location: CLLocation.init(latitude: 57.5088525, longitude: 24.7230711), radius: 2000),
		City.init(name: "Līvāni", location: CLLocation.init(latitude: 56.3537345, longitude: 26.1749847), radius: 2000),
		City.init(name: "Lubāna", location: CLLocation.init(latitude: 56.8972742, longitude: 26.7195244), radius: 2000),
		City.init(name: "Ludza", location: CLLocation.init(latitude: 56.5444057, longitude: 27.7182859), radius: 2000),
		City.init(name: "Madona", location: CLLocation.init(latitude: 56.8534898, longitude: 26.2222404), radius: 2000),
		City.init(name: "Mazsalaca", location: CLLocation.init(latitude: 57.861627, longitude: 25.0531379), radius: 1500),
		City.init(name: "Ogre", location: CLLocation.init(latitude: 56.8138852, longitude: 24.606722), radius: 3000),
		City.init(name: "Olaine", location: CLLocation.init(latitude: 56.7904994, longitude: 23.9227868), radius: 2000),
		City.init(name: "Pāvilosta", location: CLLocation.init(latitude: 56.8821485, longitude: 21.1915925), radius: 2000),
		City.init(name: "Piltene", location: CLLocation.init(latitude: 57.2241503, longitude: 21.6928837), radius: 2000),
		City.init(name: "Piltene", location: CLLocation.init(latitude: 57.2265883, longitude: 21.7260935), radius: 2000),
		City.init(name: "Piltene", location: CLLocation.init(latitude: 57.227341, longitude: 21.7568443), radius: 2000),
		City.init(name: "Pļaviņas", location: CLLocation.init(latitude: 56.6131836, longitude: 25.7324803), radius: 3000),
		City.init(name: "Preiļi", location: CLLocation.init(latitude: 56.2915751, longitude: 26.7267944), radius: 2000),
		City.init(name: "Priekule", location: CLLocation.init(latitude: 56.5216201, longitude: 21.5114058), radius: 7000),
		City.init(name: "Priekule", location: CLLocation.init(latitude: 56.4375458, longitude: 21.5306466), radius: 7000),
		City.init(name: "Priekule", location: CLLocation.init(latitude: 56.3683132, longitude: 21.5411478), radius: 7000),
		City.init(name: "Rēzekne", location: CLLocation.init(latitude: 56.5077955, longitude: 27.3482903), radius: 3000),
		rigaCity,
		City.init(name: "Rūjiena", location: CLLocation.init(latitude: 57.8945958, longitude: 25.3421038), radius: 2500),
		City.init(name: "Sabile", location: CLLocation.init(latitude: 57.0438521, longitude: 22.5747649), radius: 1800),
		City.init(name: "Salacgrīva", location: CLLocation.init(latitude: 57.767174, longitude: 24.3403899), radius: 3000),
		City.init(name: "Salaspils", location: CLLocation.init(latitude: 56.8617546, longitude: 24.359985), radius: 3000),
		City.init(name: "Saldus", location: CLLocation.init(latitude: 56.6663751, longitude: 22.4899603), radius: 2200),
		City.init(name: "Saulkrasti", location: CLLocation.init(latitude: 57.2574957, longitude: 24.4068359), radius: 2000),
		City.init(name: "Seda", location: CLLocation.init(latitude: 57.6535572, longitude: 25.7479439), radius: 1000),
		City.init(name: "Sigulda", location: CLLocation.init(latitude: 57.1590706, longitude: 24.845347), radius: 2500),
		City.init(name: "Skrunda", location: CLLocation.init(latitude: 56.6710669, longitude: 22.0091276), radius: 2000),
		City.init(name: "Smiltene", location: CLLocation.init(latitude: 57.4225013, longitude: 25.8990442), radius: 2000),
		City.init(name: "Staicele", location: CLLocation.init(latitude: 57.8337271, longitude: 24.7597616), radius: 1500),
		City.init(name: "Stende", location: CLLocation.init(latitude: 57.1417438, longitude: 22.5377921), radius: 1500),
		City.init(name: "Strenči", location: CLLocation.init(latitude: 57.6266804, longitude: 25.689515), radius: 1100),
		City.init(name: "Subate", location: CLLocation.init(latitude: 56.008816, longitude: 25.9149495), radius: 2100),
		City.init(name: "Talsi", location: CLLocation.init(latitude: 57.246451, longitude: 22.5872502), radius: 3000),
		City.init(name: "Tukums", location: CLLocation.init(latitude: 56.9677538, longitude: 23.1533432), radius: 3000),
		City.init(name: "Valdemārpils", location: CLLocation.init(latitude: 57.3672443, longitude: 22.5920149), radius: 1800),
		City.init(name: "Valka", location: CLLocation.init(latitude: 57.7760211, longitude: 26.0138205), radius: 3000),
		City.init(name: "Valmiera", location: CLLocation.init(latitude: 57.5340087, longitude: 25.409779), radius: 3200),
		City.init(name: "Vangaži", location: CLLocation.init(latitude: 57.09208, longitude: 24.5297418), radius: 2000),
		City.init(name: "Varakļāni", location: CLLocation.init(latitude: 56.6039957, longitude: 26.7564103), radius: 1800),
		City.init(name: "Ventspils", location: CLLocation.init(latitude: 57.4148732, longitude: 21.5842849), radius: 6500),
		City.init(name: "Viesīte", location: CLLocation.init(latitude: 56.3446682, longitude: 25.5596169), radius: 1200),
		City.init(name: "Viļaka", location: CLLocation.init(latitude: 57.1871085, longitude: 27.6873167), radius: 2000),
		City.init(name: "Viļāni", location: CLLocation.init(latitude: 56.5484789, longitude: 26.9313441), radius: 2000),
		City.init(name: "Zilupe", location: CLLocation.init(latitude: 56.3923723, longitude: 28.1206763), radius: 2000)
	]

	class func getClosestCity() -> City {
		if AppSettingsWorker.shared.getGPSIsEnabled() == false {
			return rigaCity
		}

		var closestCity = rigaCity
	  	var smallestDistance: CLLocationDistance?

	  	for city in cities {
			let distance = AppSettingsWorker.shared.userLocation!.distance(from: city.location)
			if smallestDistance == nil || (distance - Double(city.radius)) < smallestDistance! {
				closestCity = city
				smallestDistance = (distance - Double(city.radius))
			}
	  	}

	  	return closestCity
	}

	class func getClosestCity(from userLocation: CLLocation) -> City {
		if AppSettingsWorker.shared.getGPSIsEnabled() == false {
			return rigaCity
		}
		
		var closestCity = rigaCity
	  	var smallestDistance: CLLocationDistance?

	  	for city in cities {
			let distance = userLocation.distance(from: city.location)
			if smallestDistance == nil || (distance - Double(city.radius)) < smallestDistance! {
				closestCity = city
				smallestDistance = (distance - Double(city.radius))
			}
	  	}

	  	return closestCity
	}

	class func getCitiesByDistance() -> [CityAndDistance] {

		if AppSettingsWorker.shared.getGPSIsEnabled() == false {
			return CityWorker.getCitiesByName()
		}

		var dict: [String: Double] = [:]
		var array: [CityAndDistance] = []

		for city in cities {
			let distance = AppSettingsWorker.shared.userLocation!.distance(from: city.location)

			if let value = dict[city.name], value > (distance - Double(city.radius))  {
				dict[city.name] = (distance - Double(city.radius)) / 1000
			} else {
				dict[city.name] = (distance - Double(city.radius)) / 1000
			}
		}

		for (key, value) in dict {
			array.append(CityAndDistance.init(name: key, distanceInKm: value))
		}

		array.sort(by: { $0.distanceInKm < $1.distanceInKm })

	  	return array
	}

	class func getCitiesByName() -> [CityAndDistance] {

		var dict: [String: Double] = [:]
		var array: [CityAndDistance] = []

		for city in cities {
			dict[city.name] = 0
		}

		for (key, _) in dict {
			array.append(CityAndDistance.init(name: key, distanceInKm: 0))
		}

		array.sort(by: { $0.name < $1.name })

	  	return array
	}
}
