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

/*
	{
	"city":"Piņķi",
	"name":"KOOL Piņķi",
	"price":1.002,
	"id":1,
	"date":1591529164,
	"priority":false, // true for homepages, false for waze.
	"address":"Vēja ziedi",
	"type":"type-diesel"
	}
*/
	let city: String
	let name: String
	let price: String
	let id: Int
	let date: Double
	let priority: Bool
	let address: String
	let type: String
	let stationId: Int
}


struct CompanyRequestCodable: Codable {
	let companies: [CompanyCodable]
}

struct CompanyCodable: Codable {
	let name: String
	let hidden: Bool
	let order: Int
	let description: [String: String]?
	let homepage: String?
	let logo: [String: String]?
	let largeLogo: [String: String]?
	let mapLogo: [String: String]?
	let mapGrayLogo: [String: String]?
}


struct AAA: Codable {
	let features: [BBB]
}

struct BBB: Codable {
	let geometry: [String:CCC]
}

struct CCC: Codable {
	let coordinates: [Double]
	let type: String
}
//
//["features": <__NSArrayI 0x109029200>(
//{
//    geometry =     {
//        coordinates =         (
//            "-122.713348173023704",
//            "45.4564372138604"
//        );
//        type = Point;
//    };
//    id = 0;
//    properties =     {
//        AssetID = "2430-0051536";
//        ElectricMo = 34481;
//        Electricia = NotAssigned;
//        Engineer = NotAssigned;
//        ImagePath = "<null>";
//        IsMetered = "<null>";
//        LIP = "<null>";
//        LampCode = 86;
//        LampCodeDe = "25,500-L,250-W,HPS,COBRA HEAD - POWER DOOR";
//        LightID = 198761;
//        LocationID = BF58671;
//        MaintResp = PGE;
//        Manufactur = "<null>";
//        MastArmLen = 16;
//        Owner = PDXTRANS;
//        PoleNumber = 413000054;
//        PowerSuppl = PGE;
//        Rotation = 0;
//        SerialNumb = "<null>";
//        StLightCir = 0;
//        SupplyVolt = "<null>";
//    };
//    type = Feature;
//},



struct AddressRequestCodable: Codable {
	let items: [AddressCodable]
}

struct AddressCodable: Codable {
	let id: Int
	let company: String
	let latitude: Double
	let longitude: Double
	let city: String
	let address: String
	let name: String
}
