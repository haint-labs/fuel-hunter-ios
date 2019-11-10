//
//  MapPoint.swift
//  fuelhunter
//
//  Created by Guntis on 19/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit

class MapPoint: NSObject, MKAnnotation {
	var priceId: String // Used for price obj, which contain multiple addresses (mapPoints)
    var title: String?
    var company: Company
    var address: String
    var coordinate: CLLocationCoordinate2D
    var priceText: String
    var distanceInMeters: Double
	var priceIsCheapest: Bool

	
    init(priceId: String, title: String, company: Company, address: String, coordinate: CLLocationCoordinate2D, priceText: String, distanceInMeters: Double, priceIsCheapest: Bool) {
    	self.priceId = priceId
        self.title = title
        self.company = company
        self.address = address
        self.coordinate = coordinate
        self.priceText = priceText
        self.distanceInMeters = distanceInMeters
        self.priceIsCheapest = priceIsCheapest
    }
}
