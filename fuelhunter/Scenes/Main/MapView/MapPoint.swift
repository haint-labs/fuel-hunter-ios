//
//  MapPoint.swift
//  fuelhunter
//
//  Created by Guntis on 19/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import MapKit
import UIKit

class MapPoint: NSObject, MKAnnotation {
	var priceId: String // Used for price obj, which contain multiple addresses (mapPoints)
    var title: String?
    var companyName: String
    var address: String
    var coordinate: CLLocationCoordinate2D
    var companyBigImageName: String
    var companyBigGrayImageName: String
    var priceText: String
    var distance: Double
	var priceIsCheapest: Bool
	
    init(priceId: String, title: String, companyName: String, address: String, coordinate: CLLocationCoordinate2D, companyBigImageName: String, companyBigGrayImageName: String, priceText: String, distance: Double, priceIsCheapest: Bool) {
    	self.priceId = priceId
        self.title = title
        self.companyName = companyName
        self.address = address
        self.coordinate = coordinate
        self.companyBigImageName = companyBigImageName
        self.companyBigGrayImageName = companyBigGrayImageName
        self.priceText = priceText
        self.distance = distance
        self.priceIsCheapest = priceIsCheapest
    }
}
