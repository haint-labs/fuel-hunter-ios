//
//  NesteMapOverlay.swift
//  fuelhunter
//
//  Created by Guntis on 29/10/2020.
//  Copyright © 2020 myEmerg. All rights reserved.
//

import Foundation
import MapKit

class NesteMapOverlay: MKOverlayRenderer {

	@IBOutlet var icon: UIImage! = UIImage(named: "Intro_icon")

	override init(overlay: MKOverlay) {
		super.init(overlay: overlay)

		
  	}

	override func draw(_ mapRect: MKMapRect, zoomScale: MKZoomScale, in context: CGContext) {


//		print("zoomScale %f", zoomScale)
//		print("mapRect.size.width %f", mapRect.size.width);

		let adjustedWidth = min(2097152, mapRect.size.width);

        context.saveGState()

		let bgImageReference = UIImage(named: "area_tiny_map_pop_up")!.cgImage!

        let imageReference = icon.cgImage!

        let theMapRect = overlay.boundingMapRect
        let theRect = rect(for: theMapRect)
		context.scaleBy(x: 1, y: -1)

//		let aRect = CGRect.init(origin: CGPoint.init(x: theRect.minX, y: theRect.minY), size: CGSize.init(width: 200, height: 200))


		let aBgRect = CGRect.init(origin: CGPoint.init(x: theRect.minX, y: theRect.minY), size: CGSize.init(width: 30000, height: 30000))
		let aImageRect = CGRect.init(origin: CGPoint.init(x: theRect.minX+1000, y: theRect.minY+1000), size: CGSize.init(width: 28000, height: 28000))


//		let aRect = CGRect.init(origin: CGPoint.init(x: theRect.minX, y: theRect.minY), size: CGSize.init(width: max(300, CGFloat(adjustedWidth / 20)), height: max(300, CGFloat(adjustedWidth / 20))))

//		let aRect = CGRect.init(origin: CGPoint.init(x: theRect.minX, y: theRect.minY), size: CGSize.init(width: max(300, CGFloat(adjustedWidth / 20)), height: max(300, CGFloat(adjustedWidth / 20))))

        context.translateBy(x: aBgRect.size.width, y: -aBgRect.size.height*2)
        context.draw(bgImageReference, in: aBgRect)
        context.draw(imageReference, in: aImageRect)

        context.restoreGState()

    }

}
