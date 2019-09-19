//
//  MapLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit

class MapLayoutView: UIView {

	@IBOutlet var baseView: UIView!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet weak var topShadowImageView: UIImageView!
	@IBOutlet weak var bottomShadowImageView: UIImageView!

	var mapBottomConstraint: NSLayoutConstraint!

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("MapLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		topShadowImageView.translatesAutoresizingMaskIntoConstraints = false
		bottomShadowImageView.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
//		topShadowImageView.alpha = 0
//		bottomShadowImageView.alpha = 0
		
		topShadowImageView.topAnchor.constraint(equalTo: topAnchor, constant: -100).isActive = true
		topShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		topShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		topShadowImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
//
//		mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//		mapBottomConstraint = mapView.bottomAnchor.constraint(equalTo: bottomAnchor)
//		mapBottomConstraint.isActive = true
//		mapView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//		mapView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


		mapView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		mapView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
//
		bottomShadowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 50).isActive = true
		bottomShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		bottomShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		bottomShadowImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
		
  	}

	// MARK: Functions

	func updateMapView(with data: [MapPoint]) {
//		mapView.addAnnotations(data)
		mapView.showAnnotations(data, animated: false)

		let span = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
		let region = MKCoordinateRegion(center: data.first!.coordinate, span: span)
        mapView.setRegion(region, animated: false)

self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, edgePadding: UIEdgeInsets.init(top: 0, left: 0, bottom: 200, right: 0), animated: false)

//mapView.clipsToBounds = false
//		mapView.layoutMargins = UIEdgeInsets.init(top: 0, left: 0, bottom: 400, right: 0)
//		mapBottomConstraint.constant = -200

//		MKMapCamera.init(lookingAtCenter: <#T##CLLocationCoordinate2D#>, fromDistance: <#T##CLLocationDistance#>, pitch: <#T##CGFloat#>, heading: <#T##CLLocationDirection#>)
//		let camera = MKMapCamera.init(lookingAtCenter: mapView.centerCoordinate, fromDistance: 1000, pitch: 0, heading: 0)
//    	mapView.setCamera(camera, animated: false)
//
//		var center = mapView.centerCoordinate
////		center.latitude -= mapView.region.span.latitudeDelta * 1.10;
//		mapView.setCenter(center, animated: false)

//		var point = mapView.convert(mapView.centerCoordinate, toPointTo: view)
//		point.y -= offset
//		let coordinate = mapView.convert(point, toCoordinateFrom: view)
//		let offsetLocation = coordinate.location
//
//		let distance = mapView.centerCoordinate.location.distance(from: offsetLocation) / 1000.0
//
//		let camera = mapView.camera
//		let adjustedCenter = mapView.centerCoordinate.adjust(by: distance, at: camera.heading - 180.0)
//		camera.centerCoordinate = adjustedCenter


//		CLLocationCoordinate2D center = coordinate;
//		center.latitude -= mapView.region.span.latitudeDelta * 0.40;
//		[self.mapView setCenterCoordinate:center animated:YES];

//		let region = MKCoordinateRegion.init(center: data.first!.coordinate, span: MKCoordinateSpan.init(latitudeDelta: 0.008, longitudeDelta: 0.008))
//		let mapRect = MKMa .init(region)
////		MKCoordinateRegion region = MKCoordinateRegionMake(data.first?.coordinate, MKCoordinateSpanMake(0.008, 0.008));
////		MKMapRect mapRect = MKMapRectForCoordinateRegion(region);
////		let mapRect = MKMapRec
//
//		mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets.init(top: 0, left: 0, bottom: 400, right: 0), animated: true)
	}
}
