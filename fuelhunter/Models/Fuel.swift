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
	case typeDD = "fuel_dd_short"
	case type95 = "fuel_95_short"
	case type98 = "fuel_98_short"
	case typeGas = "fuel_gas_short"
}


enum FuelType: String, Codable {
	case typeDD = "fuel_dd"
	case type95 = "fuel_95"
	case type98 = "fuel_98"
	case typeGas = "fuel_gas"

	var index: Int {
        switch self {
			case .typeDD:
				return 0
			case .type95:
				return 1
			case .type98:
				return 2
			case .typeGas:
				return 3
		}
    }
}

// Using this to easier calculate used companies name.
struct AllFuelTypesToogleStatus: Encodable, Decodable {
	var typeDD: Bool = false
	var type95: Bool = false
	var type98: Bool = false
	var typeGas: Bool = false
	
	func isAtLeastOneTypeEnabled() -> Bool {
		if !typeDD && !type95 && !type98 && !typeGas {
			return false
		}
		return true
	}
	
	mutating func setToDefault() {
		typeDD = true
		type95 = true
		type98 = true
		typeGas = true
	}
	
	var description: String {
		var combineString = ""
		var count = 0
		if typeDD { count += 1 }
		if type95 { count += 1 }
		if type98 { count += 1 }
		
		if count > 1 {
			if typeDD { combineString.append(ShortFuelType.typeDD.rawValue.localized()); combineString.append(", ") }
			if type95 { combineString.append(ShortFuelType.type95.rawValue.localized().trimmingCharacters(in: .whitespaces)); combineString.append(", ") }
			if type98 { combineString.append(ShortFuelType.type98.rawValue.localized().trimmingCharacters(in: .whitespaces)); combineString.append(", ") }
		} else {
			if typeDD { combineString.append(FuelType.typeDD.rawValue.localized()); combineString.append(", ") }
			if type95 { combineString.append(FuelType.type95.rawValue.localized()); combineString.append(", ") }
			if type98 { combineString.append(FuelType.type98.rawValue.localized()); combineString.append(", ") }
		}
		if typeGas { combineString.append(FuelType.typeGas.rawValue.localized()); combineString.append(", ") }
		
		if combineString.count > 0 { combineString.removeLast() }
		if combineString.count > 0 { combineString.removeLast() }
		return combineString
	}
}
