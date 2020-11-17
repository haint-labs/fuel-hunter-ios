//
//  FuelListBottomPageView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol CustomPageControlButtonLogic: class {
	func pageViewLeftSideWasPressed()
	func pageViewRightSideWasPressed()
}

protocol CustomPageControlDisplayLogic {
	func setPageCount(_ count: Int, gpsButtonVisible: Bool)
}

class CustomPageControl: UIView, CustomPageControlDisplayLogic {

	weak var controller: CustomPageControlButtonLogic?
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var leftButton: UIButton!
	@IBOutlet var rightButton: UIButton!

	var iconsArray: [UIImageView] = []

	let gpsIconOnImage = UIImage.init(named: "pageControlPageGPSIconOn")
	let gpsIconOffImage = UIImage.init(named: "pageControlPageGPSIconOff")

	let normalIconOnImage = UIImage.init(named: "pageControlPageIconOn")
	let normalIconOffImage = UIImage.init(named: "pageControlPageIconOff")

	let guide = UILayoutGuide()
	let leftSpaceGuide = UILayoutGuide()
	let rightSpaceGuide = UILayoutGuide()


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
		Bundle.main.loadNibNamed("CustomPageControl", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true

		self.addLayoutGuide(guide)
		self.addLayoutGuide(leftSpaceGuide)
		self.addLayoutGuide(rightSpaceGuide)

		leftButton.translatesAutoresizingMaskIntoConstraints = false
		rightButton.translatesAutoresizingMaskIntoConstraints = false

		leftButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		leftButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		leftButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		leftButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true

		rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		rightButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		rightButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		rightButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true


		guide.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		guide.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true


		let leftSpaceGuideConstraint = leftSpaceGuide.widthAnchor.constraint(equalToConstant: 1)
		leftSpaceGuideConstraint.priority = .defaultLow
		leftSpaceGuideConstraint.isActive = true

		let rightSpaceGuideConstraint = rightSpaceGuide.widthAnchor.constraint(equalTo: leftSpaceGuide.widthAnchor)
		rightSpaceGuideConstraint.priority = .defaultLow
		rightSpaceGuideConstraint.isActive = true

		leftSpaceGuide.leftAnchor.constraint(equalTo: guide.leftAnchor).isActive = true
		rightSpaceGuide.rightAnchor.constraint(equalTo: guide.rightAnchor).isActive = true


		leftButton.addTarget(self, action: NSSelectorFromString("leftSideButtonWasPressed"), for: .touchUpInside)
		rightButton.addTarget(self, action: NSSelectorFromString("rightSideButtonWasPressed"), for: .touchUpInside)

//		self.leftButton.backgroundColor = .green
//		self.rightButton.backgroundColor = .red



//		DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//			self.select(index: 1)
//		}
//
//		DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//			self.select(index: 2)
//		}
//
//		DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//			self.select(index: 3)
//		}
//		DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
//			self.select(index: 0)
//		}
	}

	func select(index selectedIndex: Int) {
		for (index, icon) in self.iconsArray.enumerated() {
			if index != selectedIndex {
				if icon.tag == 1 { // GPS
					if icon.image != self.gpsIconOffImage {
						icon.fadeTransition(0.2)
						icon.image = self.gpsIconOffImage
					}
				} else { // Normal
					if icon.image != self.normalIconOffImage {
						icon.fadeTransition(0.2)
						icon.image = self.normalIconOffImage
					}
				}
			} else {
				if icon.tag == 1 { // GPS
					if icon.image != self.gpsIconOnImage {
						icon.fadeTransition(0.2)
						icon.image = self.gpsIconOnImage
					}
				} else { // Normal
					if icon.image != self.normalIconOnImage {
						icon.fadeTransition(0.2)
						icon.image = self.normalIconOnImage
					}
				}
			}
		}
	}

	// MARK: CustomPageControlDisplayLogic

	func setPageCount(_ count: Int, gpsButtonVisible: Bool) {

		for imageView in iconsArray {
			imageView.removeFromSuperview()
		}

		iconsArray.removeAll()

		if count <= 0 {
			return
		}

		var previouslyCreatedIcon: UIImageView!

		if gpsButtonVisible {
			let icon = UIImageView.init(image: gpsIconOnImage)
			icon.tag = 1
			icon.contentMode = .scaleAspectFit
			self.addSubview(icon)
			iconsArray.append(icon)
			icon.translatesAutoresizingMaskIntoConstraints = false
			icon.widthAnchor.constraint(equalToConstant: 12+8).isActive = true
			icon.heightAnchor.constraint(equalToConstant: 12).isActive = true
			icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		} else {
			let icon = UIImageView.init(image: normalIconOnImage)
			icon.tag = 0
			icon.contentMode = .scaleAspectFit
			self.addSubview(icon)
			iconsArray.append(icon)
			icon.translatesAutoresizingMaskIntoConstraints = false
			icon.widthAnchor.constraint(equalToConstant: 7+8).isActive = true
			icon.heightAnchor.constraint(equalToConstant: 7).isActive = true
			icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		}

		previouslyCreatedIcon = iconsArray.first!


		let sequence = 1..<count

		for _ in sequence {
			let icon = UIImageView.init(image: normalIconOffImage)
			icon.tag = 0
			icon.contentMode = .scaleAspectFit
			self.addSubview(icon)
			iconsArray.append(icon)
			icon.translatesAutoresizingMaskIntoConstraints = false
			icon.widthAnchor.constraint(equalToConstant: 7+8).isActive = true
			icon.heightAnchor.constraint(equalToConstant: 7).isActive = true
			icon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
			icon.leftAnchor.constraint(equalTo: previouslyCreatedIcon.rightAnchor).isActive = true
			previouslyCreatedIcon = icon
		}


		let firstIcon = iconsArray.first!
		let lastIcon = iconsArray.last!

		firstIcon.leftAnchor.constraint(equalTo: leftSpaceGuide.rightAnchor).isActive = true
		lastIcon.rightAnchor.constraint(equalTo: rightSpaceGuide.leftAnchor).isActive = true
	}

	// MARK: Functions

	@objc private func leftSideButtonWasPressed() {
		controller?.pageViewLeftSideWasPressed()
	}

	@objc private func rightSideButtonWasPressed() {
		controller?.pageViewRightSideWasPressed()
	}
}
