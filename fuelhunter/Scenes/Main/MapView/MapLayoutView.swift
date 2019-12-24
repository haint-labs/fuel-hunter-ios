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
	func updateMapView(with data: [MapPoint], andOffset offset: CGFloat, andRatio ratio: Double)
	func updateMapViewOffset(offset: CGFloat, ratio: Double, animated: Bool)
}

class MapLayoutView: UIView, MKMapViewDelegate, MapLayoutViewDataLogic, UIGestureRecognizerDelegate {

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

	var currentMapOffset: CGFloat = 0
	var zoomOnUserWasDone: Bool = false

	var currentActivePin: MapPoint?

	var allPinsMapRect: MKMapRect!
	var selectedPinMapRect: MKMapRect!

	var offsetRatio: Double = 1

	var userDraggedOrZoomedMap: Bool = false

	var disableMapAdjusting: Bool = false

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

		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragOrPinchMap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.didDragOrPinchMap(_:)))
        panGesture.delegate = self
        pinchGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        mapView.addGestureRecognizer(pinchGesture)
  	}

	// MARK: Functions

	func regionFor(mapPoints points: [MapPoint]) -> MKCoordinateRegion {
		var r = MKMapRect.null

		for i in 0 ..< points.count {
			let p = MKMapPoint(points[i].coordinate)
			r = r.union(MKMapRect(x: p.x, y: p.y, width: 0, height: 0))
		}

//		if mapView!.userLocation.location != nil {
//			let p = MKMapPoint(mapView!.userLocation.coordinate)
//			r = r.union(MKMapRect(x: p.x, y: p.y, width: 0, height: 0))
//		}

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

	func zoomOnAllPins(animated: Bool) {

		if !disableMapAdjusting {
			if self.userDraggedOrZoomedMap == true { disableMapAdjusting = true }

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
				self.userDraggedOrZoomedMap = false
				self.disableMapAdjusting = false
			})

			UIView.animate(withDuration: 0.2, delay: 0, options: .allowUserInteraction, animations: {
				self.mapView.setVisibleMapRect(self.allPinsMapRect, edgePadding: UIEdgeInsets(top: self.calculatedMaxPinHeight + 15, left: self.calculatedMaxPinWidth / 2 + 5, bottom: self.currentMapOffset + 5, right: self.calculatedMaxPinWidth / 2 + 5), animated: self.userDraggedOrZoomedMap == true ? true : animated)
			}) { (result) in }
		}
	}

	func recalculateMapRect() {
		let allPins = mapView.annotations.compactMap { $0 as? MapPoint }
		let allPinsRegion = self.regionFor(mapPoints: allPins)
		allPinsMapRect = MKMapRectForCoordinateRegion(region: allPinsRegion)

		if let currentActivePin = currentActivePin {
			let allPinsRegion = self.regionFor(mapPoints: [currentActivePin])
			selectedPinMapRect = MKMapRectForCoordinateRegion(region: allPinsRegion)
		} else {
			selectedPinMapRect = allPinsMapRect
		}
	}

	// MARK: MapLayoutViewDataLogic

	func updateMapView(with data: [MapPoint], andOffset offset: CGFloat, andRatio ratio: Double) {

		mapView.removeAnnotations(mapView.annotations)
		mapView.addAnnotations(data)
		offsetRatio = ratio
		recalculateMapRect()
	}

	func updateMapViewOffset(offset: CGFloat, ratio: Double, animated: Bool) {

		offsetRatio = ratio
		currentMapOffset = offset

		zoomOnAllPins(animated: animated)
	}

	// MARK: MKMapViewDelegate

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func didDragOrPinchMap(_ sender: UIGestureRecognizer) {
            userDraggedOrZoomedMap = true
    }

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

			var distance: Double = mapPointAnnotation.distanceInMeters/1000
			distance = distance.rounded(rule: .down, scale: 1)

			// This is needed, otherwise, I noticed that in some cases, more than one gets added..
			let mapPinAccessory = annotationView.viewWithTag(333) as? MapPinAccessoryView ?? MapPinAccessoryView()
			mapPinAccessory.icon.image = UIImage(named: mapPointAnnotation.company.mapGrayLogoName)
			mapPinAccessory.icon.highlightedImage = UIImage(named: mapPointAnnotation.company.mapLogoName)
			mapPinAccessory.priceLabel.text = mapPointAnnotation.priceText

			if (distance > 3) {
				mapPinAccessory.setDistanceVisible(false)
			} else if(distance >= 0.2) {
				mapPinAccessory.distanceLabel.text = "\(distance) \("map_kilometers".localized())"
				mapPinAccessory.setDistanceVisible(AppSettingsWorker.shared.getGPSIsEnabled())
			} else {
				mapPinAccessory.distanceLabel.text = "\(Int(mapPointAnnotation.distanceInMeters)) \("map_meters".localized())"
				mapPinAccessory.setDistanceVisible(AppSettingsWorker.shared.getGPSIsEnabled())
			}


			mapPinAccessory.layoutIfNeeded()
			mapPinAccessory.tag = 333


			calculatedMaxPinWidth = max(mapPinAccessory.frame.width, calculatedMaxPinWidth)
			calculatedMaxPinHeight = max(mapPinAccessory.frame.height, calculatedMaxPinHeight)

			annotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 1)
			annotationView.addSubview(mapPinAccessory)

			annotationView.frame = mapPinAccessory.frame

			if let currentActivePin = currentActivePin {
				if mapPointAnnotation == currentActivePin {
					mapPinAccessory.setAsSelected(true)
				} else {
					mapPinAccessory.setAsSelected(false)
				}
			}
		}

		return annotationView
	}

	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		guard !(view.annotation is MKUserLocation) else { return }

		controller?.mapPinWasPressed(view.annotation as! MapPoint)
	}

	func selectedPin(_ selectedPin: MapPoint) {
		currentActivePin = selectedPin
		recalculateMapRect()
		let actuals = mapView.annotations.compactMap { $0 as? MapPoint }

		for(_, mapPoint) in actuals.enumerated() {
			if let annotationView = mapView.view(for: mapPoint) {
				let mapPinAccessoryView = annotationView.viewWithTag(333) as? MapPinAccessoryView
				if mapPoint == currentActivePin! {
					mapPinAccessoryView?.setAsSelected(true)
				} else {
					mapPinAccessoryView?.setAsSelected(false)
				}
			}
		}
	}

	func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
		if !zoomOnUserWasDone {
			zoomOnAllPins(animated: true)
			zoomOnUserWasDone = true
		}
	}
}
