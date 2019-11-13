//
//  GasType.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

// Used for showing only..
enum ShortFuelType: String, Codable {
	case type95 = "fuel_95_short"
	case type98 = "fuel_98_short"
	case typeDD = "fuel_dd_short"
	case typeDDPro = "fuel_dd_pro_short"
	case typeGas = "fuel_gas_short"
}


enum FuelType: String, Codable {
	case type95 = "fuel_95"
	case type98 = "fuel_98"
	case typeDD = "fuel_dd"
	case typeDDPro = "fuel_dd_pro"
	case typeGas = "fuel_gas"
}

// Using this to easier calculate used companies name.
struct AllFuelTypesToogleStatus: Encodable, Decodable {
	var type95: Bool = false
	var type98: Bool = false
	var typeDD: Bool = false
	var typeDDPro: Bool = false
	var typeGas: Bool = false
	
	func isAtLeastOneTypeEnabled() -> Bool {
		if !type95 && !type98 && !typeDD && !typeDDPro && !typeGas {
			return false
		}
		return true
	}
	
	mutating func setToDefault() {
		type95 = true
		type98 = true
		typeDD = true
		typeDDPro = true
		typeGas = true
	}
	
	var description: String {
		var combineString = ""
		var count = 0
		if type95 { count += 1 }
		if type98 { count += 1 }
		if typeDD { count += 1 }
		if typeDDPro { count += 1 }
		
		if count > 1 {
			if type95 { combineString.append(ShortFuelType.type95.rawValue.localized().trimmingCharacters(in: .whitespaces)); combineString.append(", ") }
			if type98 { combineString.append(ShortFuelType.type98.rawValue.localized().trimmingCharacters(in: .whitespaces)); combineString.append(", ") }
			if typeDD { combineString.append(ShortFuelType.typeDD.rawValue.localized()); combineString.append(", ") }
			if typeDDPro { combineString.append(ShortFuelType.typeDDPro.rawValue.localized()); combineString.append(", ") }
		} else {
			if type95 { combineString.append(FuelType.type95.rawValue.localized()); combineString.append(", ") }
			if type98 { combineString.append(FuelType.type98.rawValue.localized()); combineString.append(", ") }
			if typeDD { combineString.append(FuelType.typeDD.rawValue.localized()); combineString.append(", ") }
			if typeDDPro { combineString.append(FuelType.typeDDPro.rawValue.localized()); combineString.append(", ") }
		}
		if typeGas { combineString.append(FuelType.typeGas.rawValue.localized()); combineString.append(", ") }
		
		if combineString.count > 0 { combineString.removeLast() }
		if combineString.count > 0 { combineString.removeLast() }
		return combineString
	}
}
