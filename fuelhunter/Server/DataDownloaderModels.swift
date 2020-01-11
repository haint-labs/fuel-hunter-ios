//
//  DataDownloaderModels.swift
//  fuelhunter
//
//  Created by Guntis on 29/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct PriceRequestCodable: Codable {
	let prices: [PriceCodable]
}

struct PriceCodable: Codable {
	let price: String
	let fuelType: String
	let company: String
	let city: String
	let addresses: [DownloadedAddress]

	struct DownloadedAddress: Codable {
		var name: String
		var latitude: Double
		var longitude: Double
	}

//	enum CodingKeys: String, CodingKey
//    {
//        case price = "price"
//        case fuelType = "fuelType"
//        case company = "company"
//        case city = "city"
//        case addresses = "addresses"
//    }
}


struct CompanyRequestCodable: Codable {
	let companies: [CompanyCodable]
}

struct CompanyCodable: Codable {
	let name: String
	let order: Int
	let homepage: String
	let description: [String: String]
	let logo: [String: String]
	let largeLogo: [String: String]
	let mapLogo: [String: String]
	let mapGrayLogo: [String: String]
}
