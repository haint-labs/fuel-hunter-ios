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
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String

    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}
