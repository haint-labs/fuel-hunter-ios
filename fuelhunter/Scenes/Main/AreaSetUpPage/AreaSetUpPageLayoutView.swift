//
//  AreaSetUpPageLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol AreaSetUpPageLayoutViewLogic: class {
	func nextButtonPressed()
	func cancelButtonPressed()
	func stepperPressed(value: Int)
	func chooseCityButtonPressed(with frame: CGRect)
}

protocol AreaSetUpPageLayoutViewDataLogic: class {
	func updateData(data: AreaSetUpPage.SetUp.ViewModel)
	func appMovedToForeground()
	func appMovedToBackground()
	func animateBackgroundImageColorToState(visible: Bool)
}

class AreaSetUpPageLayoutView: UIView, AreaSetUpPageLayoutViewDataLogic, MKMapViewDelegate, UIGestureRecognizerDelegate {

	weak var controller: AreaSetUpPageLayoutViewLogic?

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontViewContainer: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet weak var nextButton: UIButton!
	@IBOutlet var backgroundDismissButton: UIButton!
	@IBOutlet var cancelButton: UIButton!
	@IBOutlet var mapView: MKMapView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var selectedMapRadiusImageView: UIImageView!


	var storedZoomRatio: Int = 0
	var selectedRadius: Double = 0
	var centerLocation: CLLocation!

	var allAnnotationViews = [TinyMapPinAccessoryView]()

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("AreaSetUpPageLayoutView", owner: self, options: nil)
		addSubview(baseView)
		centerLocation = CLLocation(latitude: self.mapView.region.center.latitude, longitude: self.mapView.region.center.longitude)

		baseView.frame = self.bounds
		frontViewContainer.backgroundColor = .clear
		baseView.backgroundColor = .clear

		mapView.showsUserLocation = true
		mapView.delegate = self


		var largeOffset: CGFloat = 30
		var smallOffset: CGFloat = 20

		if UIDevice.screenType == .iPhones_4_4S {
			largeOffset = 13
			smallOffset = 4
		} else if UIDevice.screenType == .iPhones_5_5s_5c_SE {
			largeOffset = 17
			smallOffset = 10
		} else if UIDevice.screenType == .iPhones_6_6s_7_8 {
			largeOffset = 25
			smallOffset = 15
		}

		self.translatesAutoresizingMaskIntoConstraints = false
		frontViewContainer.translatesAutoresizingMaskIntoConstraints = false
		frontView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
  		baseView.translatesAutoresizingMaskIntoConstraints = false
  		titleLabel.translatesAutoresizingMaskIntoConstraints = false
  		cancelButton.translatesAutoresizingMaskIntoConstraints = false
		nextButton.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
  		backgroundDismissButton.translatesAutoresizingMaskIntoConstraints = false
		selectedMapRadiusImageView.translatesAutoresizingMaskIntoConstraints = false

  		baseView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		
  		backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 6000).isActive = true
  		backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3000).isActive = true

		frontViewContainer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		frontViewContainer.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		backgroundDismissButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundDismissButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
//		backgroundDismissButton.addTarget(self, action: NSSelectorFromString("cancelButtonPressed"), for: .touchUpInside)

  		titleLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: smallOffset).isActive = true
  		titleLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 30).isActive = true
  		titleLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -30).isActive = true

		mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: smallOffset).isActive = true
		mapView.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 0).isActive = true
  		mapView.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: 0).isActive = true
  		mapView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height-300).isActive = true
//		mapView.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -largeOffset).isActive = true

  		nextButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: smallOffset).isActive = true
  		nextButton.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -40).isActive = true
  		nextButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

  		cancelButton.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: smallOffset).isActive = true
  		cancelButton.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 40).isActive = true
  		cancelButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

		selectedMapRadiusImageView.topAnchor.constraint(equalTo: mapView.topAnchor, constant: 10).isActive = true
		selectedMapRadiusImageView.leftAnchor.constraint(equalTo: mapView.leftAnchor, constant: 10).isActive = true
  		selectedMapRadiusImageView.rightAnchor.constraint(equalTo: mapView.rightAnchor, constant: -10).isActive = true
  		selectedMapRadiusImageView.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -10).isActive = true
		selectedMapRadiusImageView.alpha = 0

		frontView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 5).isActive = true
  		let yconstraint = frontView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40)
		yconstraint.priority = .defaultHigh
		yconstraint.isActive = true
  		frontView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
  		frontView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

  		frontView.backgroundColor = .white
  		frontView.layer.cornerRadius = 10
  		frontView.layer.shadowColor = UIColor(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 0.44).cgColor
  		frontView.layer.shadowOpacity = 1
  		frontView.layer.shadowRadius = 8

  		titleLabel.font = Font(.normal, size: .size2).font
  		nextButton.setTitle("Tālāk".localized(), for: .normal)
  		nextButton.titleLabel?.font = Font(.medium, size: .size2).font
  		cancelButton.setTitle("cancel_button_title".localized(), for: .normal)
  		cancelButton.titleLabel?.font = Font(.medium, size: .size2).font

  		backgroundView.backgroundColor = .clear
  		nextButton.addTarget(self, action: NSSelectorFromString("nextButtonPressed"), for: .touchUpInside)
  		cancelButton.addTarget(self, action: NSSelectorFromString("cancelButtonPressed"), for: .touchUpInside)

		titleLabel.text = "Izvēlies lokāciju un rādiusu"


		let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.didDragOrPinchMap(_:)))
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(self.didDragOrPinchMap(_:)))
        panGesture.delegate = self
        pinchGesture.delegate = self
        mapView.addGestureRecognizer(panGesture)
        mapView.addGestureRecognizer(pinchGesture)
  	}

  	// MARK: Functions

  	@objc private func nextButtonPressed() {
  		controller?.chooseCityButtonPressed(with: frontView.frame)
  	}

  	@objc private func cancelButtonPressed() {
  		controller?.cancelButtonPressed()
  	}

  	@objc private func stepperPressed() {
//		controller?.stepperPressed(value: Int(stepper.value))
  	}

	@objc private func chooseCityButtonPressed() {
//		controller?.chooseCityButtonPressed(with: frontView.frame)
  	}

//	- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
//		if ([overlay isKindOfClass:PVParkMapOverlay.class]) {
//			UIImage *magicMountainImage = [UIImage imageNamed:@"overlay_park"];
//			PVParkMapOverlayView *overlayView = [[PVParkMapOverlayView alloc] initWithOverlay:overlay overlayImage:magicMountainImage];
//
//			return overlayView;
//		}
//
//		return nil;
//	}
//
//	func renderer(for overlay: MKOverlay) -> MKOverlayRenderer? {
////		let image = UIImage.init(named: "Intro_icon")
//
//		print("render!");
//
//		let overlay = NesteMapOverlay.init(overlay: overlay)
//		return overlay
//	}

	func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
		if let overlay = overlay as? CompanyMapOverlay {

//			overlay.radius = 100
			let circleRenderer = NesteMapOverlay.init(overlay: overlay)//MKCircleRenderer(circle: overlay)
//			circleRenderer.fillColor = UIColor.red
//			circleRenderer.icon = 
//			circleRenderer.alpha = 0.9


			if(overlay.imageNameString.contains("Neste")) {
				circleRenderer.icon = UIImage(named: "neste_big_logo@3x")
			} else if(overlay.imageNameString.contains("Circle K")) {
				circleRenderer.icon = UIImage(named: "circle_k_big_logo@3x")
			} else if(overlay.imageNameString.contains("Kool")) {
				circleRenderer.icon = UIImage(named: "kool_big_logo@3x")
			} else if(overlay.imageNameString.contains("Ingrid")) {
				circleRenderer.icon = UIImage(named: "ingrida_big_logo@3x")
			} else if(overlay.imageNameString.contains("Kings")) {
				circleRenderer.icon = UIImage(named: "kings_big_logo@3x")
			} else if(overlay.imageNameString.contains("Astarte")) {
				circleRenderer.icon = UIImage(named: "astarte_big_logo@3x")
			} else if(overlay.imageNameString.contains("VTU")) {
				circleRenderer.icon = UIImage(named: "vtu_big_logo@3x")
			} else if(overlay.imageNameString.contains("Viada")) {
				circleRenderer.icon = UIImage(named: "viada_big_logo@3x")
			} else if(overlay.imageNameString.contains("Gotika")) {
				circleRenderer.icon = UIImage(named: "gotika_big_logo@3x")
			} else if(overlay.imageNameString.contains("Dinaz")) {
				circleRenderer.icon = UIImage(named: "dinaz_big_logo@3x")
			} else if(overlay.imageNameString.contains("Rietumu")) {
				circleRenderer.icon = UIImage(named: "rn_big_logo@3x")
			} else if(overlay.imageNameString.contains("Metro")) {
				circleRenderer.icon = UIImage(named: "metro_big_logo@3x")
			} else if(overlay.imageNameString.contains("Virši")) {
				circleRenderer.icon = UIImage(named: "virshi_big_logo@3x")
			} else if(overlay.imageNameString.contains("Virāža")) {
				circleRenderer.icon = UIImage(named: "viraza_big_logo@3x")
			} else if(overlay.imageNameString.contains("Intergaz")) {
				circleRenderer.icon = UIImage(named: "intergaz_big_logo@3x")
			} else if(overlay.imageNameString.contains("MC")) {
				circleRenderer.icon = UIImage(named: "mc_big_logo@3x")
			} else if(overlay.imageNameString.contains("Geksans")) {
				circleRenderer.icon = UIImage(named: "geksans_big_logo@3x")
			} else if(overlay.imageNameString.contains("Latvijas Nafta")) {
				circleRenderer.icon = UIImage(named: "ln_big_logo@3x")
			} else if(overlay.imageNameString.contains("Straujupīte")) {
				circleRenderer.icon = UIImage(named: "totals_big_logo@3x")
			} else if(overlay.imageNameString.contains("Latvijas Propāna Gāze")) {
				circleRenderer.icon = UIImage(named: "lpg_big_logo@3x")
			} else {
				circleRenderer.icon = UIImage(named: "Intro_icon")
			}

			return circleRenderer
		}
		return MKOverlayRenderer.init()
	}

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc func didDragOrPinchMap(_ sender: UIGestureRecognizer) {
//		userDraggedOrZoomedMap = true
//	print("Abc");

//		for overlay in mapView.overlays {
//			mapView.renderer(for: overlay)?.setNeedsDisplay()
////			overlay.setNeedsDisplay()
//		}

		let zoomWidth = self.mapView.visibleMapRect.size.width

		if(self.storedZoomRatio == Int(log2(zoomWidth))) {
			return
		}

		self.storedZoomRatio = Int(log2(zoomWidth))

		centerLocation = CLLocation(latitude: self.mapView.region.center.latitude, longitude: self.mapView.region.center.longitude)

		UIView.animate(withDuration: 0.3) {

			if(Float(log2(zoomWidth)) - 9 <= 10 ) {
				self.selectedMapRadiusImageView.alpha = 1
				let furthest = CLLocation(latitude: self.mapView.region.center.latitude,
					longitude: self.mapView.region.center.longitude + (self.mapView.region.span.longitudeDelta/2))

				self.selectedRadius = self.centerLocation.distance(from: furthest)
				print("self.selectedRadius %f", self.selectedRadius)
			} else {
				self.selectedMapRadiusImageView.alpha = 0
			}

			for annotation in self.mapView.annotations {

				guard !(annotation is MKUserLocation) else {
					continue
				}

				self.setCorespondingZoomLevelBasedOnCenterLocationFor(annotation: annotation)
			}
		}
    }

	func setCorespondingZoomLevelBasedOnCenterLocationFor(annotation: MKAnnotation) {
		let zoomWidth = self.mapView.visibleMapRect.size.width
		var level = 0
		if let annotationView = self.mapView.view(for: annotation) as? TinyMapPinAccessoryView {
			if(Float(log2(zoomWidth)) - 9 <= 3 ) {
				level = 3
			} else if(Float(log2(zoomWidth)) - 9 <= 7 ) {
				level = 2
			} else if(Float(log2(zoomWidth)) - 9 <= 13 ) {
				level = 1
			}

			if(self.selectedMapRadiusImageView.alpha > 0 &&
				CLLocation(latitude: annotation.coordinate.latitude, longitude: annotation.coordinate.longitude).distance(from: centerLocation) < self.selectedRadius) {
				level = level + 1
			}

			annotationView.setAsLevel(level)
			annotationView.setNeedsDisplay()
		}
	}

	// MARK: AreaSetUpPageLayoutViewDataLogic

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {

		centerLocation = CLLocation(latitude: self.mapView.region.center.latitude, longitude: self.mapView.region.center.longitude)

		let zoomWidth = mapView.visibleMapRect.size.width


		UIView.animate(withDuration: 0.3) {

			if(Float(log2(zoomWidth)) - 9 <= 10 ) {
				self.selectedMapRadiusImageView.alpha = 1
			} else {
				self.selectedMapRadiusImageView.alpha = 0
			}


			if(Float(log2(zoomWidth)) - 9 <= 10 ) {
				self.selectedMapRadiusImageView.alpha = 1
				let furthest = CLLocation(latitude: self.mapView.region.center.latitude,
					longitude: self.mapView.region.center.longitude + (self.mapView.region.span.longitudeDelta/2))

				self.selectedRadius = self.centerLocation.distance(from: furthest)
				print("self.selectedRadius %f", self.selectedRadius)
			} else {
				self.selectedMapRadiusImageView.alpha = 0
			}

			for annotation in self.mapView.annotations {

				guard !(annotation is MKUserLocation) else {
					continue
				}

				self.setCorespondingZoomLevelBasedOnCenterLocationFor(annotation: annotation)
			}
		}
	}

	func updateData(data: AreaSetUpPage.SetUp.ViewModel) {
//		titleLabel.text = "intro_notifs_title".localized()

		let context = DataBaseManager.shared.mainManagedObjectContext()

		let fetchRequest: NSFetchRequest<AddressEntity> = AddressEntity.fetchRequest()

		let addresses = try! context.fetch(fetchRequest)

		let annotations = NSMutableArray()

		self.mapView.register(TinyMapPinAccessoryView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(TinyMapPinAccessoryView.self))

		DispatchQueue.global(qos: .background).async {

			for address in addresses {
				var imageName = ""
//
				if(address.companyName!.contains("Neste")) {
					imageName = "neste_big_logo@3x"
				} else if(address.companyName!.contains("Circle K")) {
					imageName = "circle_k_big_logo@3x"
				} else if(address.companyName!.contains("Kool")) {
					imageName = "kool_big_logo@3x"
				} else if(address.companyName!.contains("Ingrid")) {
					imageName = "ingrida_big_logo@3x"
				} else if(address.companyName!.contains("Kings")) {
					imageName = "kings_big_logo@3x"
				} else if(address.companyName!.contains("Astarte")) {
					imageName = "astarte_big_logo@3x"
				} else if(address.companyName!.contains("VTU")) {
					imageName = "vtu_big_logo@3x"
				} else if(address.companyName!.contains("Viada")) {
					imageName = "viada_big_logo@3x"
				} else if(address.companyName!.contains("Gotika")) {
					imageName = "gotika_big_logo@3x"
				} else if(address.companyName!.contains("Dinaz")) {
					imageName = "dinaz_big_logo@3x"
				} else if(address.companyName!.contains("Rietumu")) {
					imageName = "rn_big_logo@3x"
				} else if(address.companyName!.contains("Metro")) {
					imageName = "metro_big_logo@3x"
				} else if(address.companyName!.contains("Virši")) {
					imageName = "virshi_big_logo@3x"
				} else if(address.companyName!.contains("Virāža")) {
					imageName = "viraza_big_logo@3x"
				} else if(address.companyName!.contains("Intergaz")) {
					imageName = "intergaz_big_logo@3x"
				} else if(address.companyName!.contains("MC")) {
					imageName = "mc_big_logo@3x"
				} else if(address.companyName!.contains("Geksans")) {
					imageName = "geksans_big_logo@3x"
				} else if(address.companyName!.contains("Latvijas Nafta")) {
					imageName = "ln_big_logo@3x"
				} else if(address.companyName!.contains("Straujupīte")) {
					imageName = "totals_big_logo@3x"
				} else if(address.companyName!.contains("Latvijas Propāna Gāze")) {
					imageName = "lpg_big_logo@3x"
				} else {
					imageName = "Intro_icon"
				}

				let a = TinyMapPoint.init(imageName: imageName, coordinate: CLLocation.init(latitude: address.latitude, longitude: address.longitude).coordinate)
				
//				a.coordinate = CLLocation.init(latitude: address.latitude, longitude: address.longitude).coordinate
				annotations.add(a)
			}

			DispatchQueue.main.async {
				self.mapView.addAnnotations(annotations as! [MKAnnotation])
				self.mapView.showAnnotations(self.mapView.annotations, animated: false)
			}
		}
	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		guard !(annotation is MKUserLocation) else {
			return nil
		}

		var annotationView: MKAnnotationView?


		if let annotation = annotation as? TinyMapPoint {
			annotationView = setupAnnotation(for: annotation, on: mapView)
			annotationView?.frame = CGRect.init(x: 0, y: 0, width: 500, height: 500)
			annotationView?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
			annotationView?.layoutIfNeeded()
			self.setCorespondingZoomLevelBasedOnCenterLocationFor(annotation: annotation)
		}

		return annotationView
	}

	private func setupAnnotation(for annotation: TinyMapPoint, on mapView: MKMapView) -> MKAnnotationView {
		let reuseIdentifier = NSStringFromClass(TinyMapPinAccessoryView.self)
		let flagAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier, for: annotation as MKAnnotation) as! TinyMapPinAccessoryView

		flagAnnotationView.canShowCallout = false

		flagAnnotationView.iconNormal.image = UIImage.init(named: annotation.imageName)

		flagAnnotationView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

		return flagAnnotationView
	}



	func appMovedToForeground() {
	}

	func appMovedToBackground() {
	}

	func animateBackgroundImageColorToState(visible: Bool) {
		if visible {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = UIColor(named: "PopUpBackground")
			}, completion: { (finished: Bool) in })
		} else {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = .clear
			}, completion: { (finished: Bool) in })
		}
	}
}
