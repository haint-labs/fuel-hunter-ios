//
//  Company.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct Company: Equatable, Codable {
	var companyType: CompanyType
	var name: String
	var logoName: String
	var largeLogoName: String
	var mapLogoName: String
	var mapGrayLogoName: String
	var homePage: String
}
enum CompanyType: String, Codable {
	case typeCheapest = "company_type_cheapest_title"
	case typeNeste = "Neste"
	case typeCircleK = "Circle K"
	case typeKool = "Kool"
	case typeLN = "Latvijas Nafta"
	case typeVirsi = "Virsi"
	case typeGotikaAuto = "Gotika Auto"
}

// Using this to easier calculate used companies name.
struct AllCompaniesToogleStatus: Encodable, Decodable {
	var typeCheapest: Bool = true { didSet { updateAllValues() } }
	var typeNeste: Bool = false { didSet { updateAllValues() } }
	var typeCircleK: Bool = false { didSet { updateAllValues() } }
	var typeKool: Bool = false { didSet { updateAllValues() } }
	var typeLn: Bool = false { didSet { updateAllValues() } }
	var typeVirsi: Bool = false { didSet { updateAllValues() } }
	var typeGotikaAuto: Bool = false { didSet { updateAllValues() } }
	
	// This is needed so that cheapest is always on, if all others are off
	mutating func updateAllValues() {
		if !typeCheapest && !typeNeste && !typeCircleK && !typeKool && !typeLn && !typeVirsi 
			&& !typeGotikaAuto 
			{
			typeCheapest = true
		}
	}
	
	var description: String {
		if !typeNeste && !typeCircleK && !typeKool && !typeLn && !typeVirsi 
			&& !typeGotikaAuto {
			return CompanyType.typeCheapest.rawValue
		}
		
		var combineString = ""
		if typeNeste { combineString.append(CompanyType.typeNeste.rawValue); combineString.append(", ") }
		if typeCircleK { combineString.append(CompanyType.typeCircleK.rawValue); combineString.append(", ") }
		if typeKool { combineString.append(CompanyType.typeKool.rawValue); combineString.append(", ") }
		if typeLn { combineString.append(CompanyType.typeLN.rawValue); combineString.append(", ") }
		if typeVirsi { combineString.append(CompanyType.typeVirsi.rawValue); combineString.append(", ") }
		if typeGotikaAuto { combineString.append(CompanyType.typeGotikaAuto.rawValue); combineString.append(", ") }

		if combineString.count > 0 { combineString.removeLast() }
		if combineString.count > 0 { combineString.removeLast() }
		return combineString
	}
}
