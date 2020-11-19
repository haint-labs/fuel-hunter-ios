//
//  TinyMapPoint.swift
//  fuelhunter
//
//  Created by Guntis on 30/10/2020.
//  Copyright © 2020 myEmerg. All rights reserved.
//

import UIKit
import MapKit

class TinyMapPoint: NSObject, MKAnnotation {
	var coordinate: CLLocationCoordinate2D

    var imageName: String
	var address: AddressEntity!

    init(imageName: String, address: AddressEntity, coordinate: CLLocationCoordinate2D) {
    	self.imageName = imageName
    	self.coordinate = coordinate
    	self.address = address
    }
}
