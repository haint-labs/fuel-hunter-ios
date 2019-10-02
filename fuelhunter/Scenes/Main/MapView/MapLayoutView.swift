//
//  MapLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit

protocol MapLayoutViewViewLogic: class {
	func mapPinWasPressed(_ mapPoint: MapPoint)
}

protocol MapLayoutViewDataLogic: class {
	func updateMapView(with data: [MapPoint], andOffset offset: CGFloat)
	func updateMapViewOffset(offset: CGFloat, animated: Bool)
}

class MapLayoutView: UIView, MKMapViewDelegate, MapLayoutViewDataLogic {

	weak var controller: MapLayoutViewViewLogic?

	@IBOutlet var baseView: UIView!
	@IBOutlet var mapView: MKMapView!

	// These ones are white fade out, like a mask.
	@IBOutlet weak var topShadowImageView: UIImageView!
	@IBOutlet weak var bottomShadowImageView: UIImageView!

	// This is the generic one, shadow.
	@IBOutlet weak var viewTopShadow: UIImageView!

	var calculatedMaxPinWidth: CGFloat = 0
	var calculatedMaxPinHeight: CGFloat = 0

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

		mapView.showsUserLocation = true
		mapView.delegate = self

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		topShadowImageView.translatesAutoresizingMaskIntoConstraints = false
		bottomShadowImageView.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
		viewTopShadow.translatesAutoresizingMaskIntoConstraints = false

		viewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		viewTopShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		viewTopShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		viewTopShadow.topAnchor.constraint(equalTo: topAnchor).isActive = true


		topShadowImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
		topShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		topShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		topShadowImageView.heightAnchor.constraint(equalToConstant: 21).isActive = true

		mapView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		mapView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		mapView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		mapView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true


		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		bottomShadowImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 50).isActive = true
		bottomShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		bottomShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		bottomShadowImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
  	}

	// MARK: Functions

	func regionFor(mapPoints points: [MapPoint]) -> MKCoordinateRegion {
		var r = MKMapRect.null

		for i in 0 ..< points.count {
			let p = MKMapPoint(points[i].coordinate)
			r = r.union(MKMapRect(x: p.x, y: p.y, width: 0, height: 0))
		}

		var region = MKCoordinateRegion(r)

		region.span.latitudeDelta = max(0.002, region.span.latitudeDelta)
    	region.span.longitudeDelta = max(0.002, region.span.longitudeDelta)

		return region
	}

	func MKMapRectForCoordinateRegion(region:MKCoordinateRegion) -> MKMapRect {
		let topLeft = CLLocationCoordinate2D(latitude: region.center.latitude + (region.span.latitudeDelta/2), longitude: region.center.longitude - (region.span.longitudeDelta/2))
		let bottomRight = CLLocationCoordinate2D(latitude: region.center.latitude - (region.span.latitudeDelta/2), longitude: region.center.longitude + (region.span.longitudeDelta/2))

		let a = MKMapPoint(topLeft)
		let b = MKMapPoint(bottomRight)

		return MKMapRect(origin: MKMapPoint(x:min(a.x,b.x), y:min(a.y,b.y)), size: MKMapSize(width: abs(a.x-b.x), height: abs(a.y-b.y)))
	}

	// MARK: MapLayoutViewDataLogic

	func updateMapView(with data: [MapPoint], andOffset offset: CGFloat) {

		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(data)
//
//		let region = self.regionFor(mapPoints: data)
//		let mapRect = MKMapRectForCoordinateRegion(region: region)
//
//		mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: calculatedMaxPinHeight+5+10, left: calculatedMaxPinWidth/2+5, bottom: offsetForMap, right: calculatedMaxPinWidth/2+5), animated: false)
	}

	func updateMapViewOffset(offset: CGFloat, animated: Bool) {

		let region = self.regionFor(mapPoints: mapView!.annotations as! [MapPoint])
		let mapRect = MKMapRectForCoordinateRegion(region: region)

		mapView.setVisibleMapRect(mapRect, edgePadding: UIEdgeInsets(top: calculatedMaxPinHeight+5+10, left: calculatedMaxPinWidth/2+5, bottom: offset, right: calculatedMaxPinWidth/2+5), animated: false)
	}

	// MARK: MKMapViewDelegate

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		guard !(annotation is MKUserLocation) else {
			return nil
		}

		let annotationIdentifier = "mapPoint"

		var annotationView: MKAnnotationView?
		if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
			annotationView = dequeuedAnnotationView
			annotationView?.annotation = annotation
		}
		else {
			let av = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
			annotationView = av
		}

		if let annotationView = annotationView,
		   let mapPointAnnotation = annotationView.annotation as? MapPoint {
			annotationView.canShowCallout = false
			let mapPinAccessory = MapPinAccessoryView.init()
			mapPinAccessory.icon.image = UIImage(named: mapPointAnnotation.imageName)
			mapPinAccessory.priceLabel.text = mapPointAnnotation.priceText
			mapPinAccessory.distanceLabel.text = "\(mapPointAnnotation.distance) km"
			mapPinAccessory.layoutIfNeeded()

			calculatedMaxPinWidth = max(mapPinAccessory.frame.width, calculatedMaxPinWidth)
			calculatedMaxPinHeight = max(mapPinAccessory.frame.height, calculatedMaxPinHeight)

			annotationView.layer.anchorPoint = CGPoint.init(x: 0.5, y: 1)
			annotationView.addSubview(mapPinAccessory)
			annotationView.frame = mapPinAccessory.frame
		}

		return annotationView
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		controller?.mapPinWasPressed(view.annotation as! MapPoint)
	}
}
