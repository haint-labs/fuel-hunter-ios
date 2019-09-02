//
//  Address.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

struct Address: Codable, Equatable {
	var name: String
	var latitude: Double
	var longitude: Double
	
	static func == (lhs: Address, rhs: Address) -> Bool {
		return lhs.name == rhs.name
			&& lhs.latitude == rhs.latitude
			&& lhs.longitude == rhs.longitude
	}
}
