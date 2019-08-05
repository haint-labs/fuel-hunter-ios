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
	var company: Company
	var city: String
	var price: String
	var isPriceCheapest: Bool
	var fuelType: FuelType
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
			&& lhs.company == rhs.company
			&& lhs.city == rhs.city
			&& lhs.price == rhs.price
			&& lhs.isPriceCheapest == rhs.isPriceCheapest
			&& lhs.fuelType == rhs.fuelType
			&& lhs.addressDescription == rhs.addressDescription
	}
}
