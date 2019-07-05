//
//  Price.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct Price: Equatable, Codable {
	var id: String
	var companyName: String
	var companyLogoName: String
	var city: String
	var price: String
	var isPriceCheapest: Bool
	var gasType: GasType
	var address: [Address]
	var addressDescription: String {
		var fullAddress = "\(city) - "
		if self.address.count == 0 {
			return "\(city)"
		}
		for address in self.address {
			fullAddress.append("\(address.name), ")
		}
		return String(fullAddress.dropLast().dropLast())
	}
	
	static func == (lhs: Price, rhs: Price) -> Bool {
		return lhs.id == rhs.id
			&& lhs.companyName == rhs.companyName
			&& lhs.city == rhs.city
			&& lhs.price == rhs.price
			&& lhs.isPriceCheapest == rhs.isPriceCheapest
			&& lhs.gasType == rhs.gasType
			&& lhs.addressDescription == rhs.addressDescription
	}
}

struct Address: Codable {
	var name: String
	var latitude: Double
	var longitude: Double
}

enum GasType: String, Codable {
	case type95 = "95 | Benzīns"
	case type98 = "98 | Benzīns"
	case typeDD = "DD | Dīzeļdegviela"
	case typeDDPro = "DD | Pro Dīzeļdegviela"
	case typeGas = "Auto gāze"
}

