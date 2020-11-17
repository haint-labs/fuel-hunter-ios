//
//  CompanyMapOverlay.swift
//  fuelhunter
//
//  Created by Guntis on 30/10/2020.
//  Copyright © 2020 myEmerg. All rights reserved.
//

import Foundation
import MapKit

class CompanyMapOverlay: MKCircle {

	var imageNameString: String = ""

	class func circleAtCenterCoordinate(center coord: CLLocationCoordinate2D, radius: CLLocationDistance, imageName: String) -> CompanyMapOverlay {
        let circ=CompanyMapOverlay(center: coord, radius: radius)
        circ.imageNameString = imageName
        return circ
    }
}
