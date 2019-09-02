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
	case type95 = "95"
	case type98 = "98"
	case typeDD = "DD"
	case typeDDPro = "DD Pro"
	case typeGas = "Auto gāze"
}


enum FuelType: String, Codable {
	case type95 = "95 | Benzīns"
	case type98 = "98 | Benzīns"
	case typeDD = "DD | Dīzeļdegviela"
	case typeDDPro = "DD | Pro Dīzeļdegviela"
	case typeGas = "Auto gāze"
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
			if type95 { combineString.append(ShortFuelType.type95.rawValue); combineString.append(", ") }
			if type98 { combineString.append(ShortFuelType.type98.rawValue); combineString.append(", ") }
			if typeDD { combineString.append(ShortFuelType.typeDD.rawValue); combineString.append(", ") }
			if typeDDPro { combineString.append(ShortFuelType.typeDDPro.rawValue); combineString.append(", ") }
		} else {
			if type95 { combineString.append(FuelType.type95.rawValue); combineString.append(", ") }
			if type98 { combineString.append(FuelType.type98.rawValue); combineString.append(", ") }
			if typeDD { combineString.append(FuelType.typeDD.rawValue); combineString.append(", ") }
			if typeDDPro { combineString.append(FuelType.typeDDPro.rawValue); combineString.append(", ") }
		}
		if typeGas { combineString.append(FuelType.typeGas.rawValue); combineString.append(", ") }
		
		if combineString.count > 0 { combineString.removeLast() }
		if combineString.count > 0 { combineString.removeLast() }
		return combineString
	}
}
