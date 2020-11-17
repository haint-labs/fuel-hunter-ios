//
//  MapPinAccessoryView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import MapKit
protocol TinyMapPinAccessoryViewDisplayLogic {
	func setAsLevel(_ tiny: Int)
}

class TinyMapPinAccessoryView: MKAnnotationView, TinyMapPinAccessoryViewDisplayLogic {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var iconNormal: UIImageView!

	var isLevel: Int = 1

	var iconTopConstraint: NSLayoutConstraint!
	var iconLeftConstraint: NSLayoutConstraint!
	var iconRightConstraint: NSLayoutConstraint!
	var iconBottomConstraint: NSLayoutConstraint!

	var iconNormalWidthConstraint: NSLayoutConstraint!
	var iconNormalHeightConstraint: NSLayoutConstraint!


	// MARK: View lifecycle

	override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
		super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
		setup()
	}

//	override init(frame: CGRect) {
//   	super.init(frame: frame)
//		setup()
//  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	private func setup() {
//		self.frame = CGRect.init(x: 0, y: 0, width: 50, height: 50)
		Bundle.main.loadNibNamed("TinyMapPinAccessoryView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		// For icons. We need to compensate, so that it would nice, when showing price + distance.
		let increaseIconSize: CGFloat = CGFloat(max(0, Font.increaseFontSize)) * 2

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		iconNormal.translatesAutoresizingMaskIntoConstraints = false

		baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		iconLeftConstraint = iconNormal.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
		iconTopConstraint = iconNormal.topAnchor.constraint(equalTo: topAnchor, constant: 4)
		iconBottomConstraint = iconNormal.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)
		iconRightConstraint = iconNormal.rightAnchor.constraint(equalTo: rightAnchor, constant: -4)

		iconLeftConstraint.isActive = true
		iconTopConstraint.isActive = true
		iconBottomConstraint.isActive = true
		iconRightConstraint.isActive = true

		iconNormalWidthConstraint = iconNormal.heightAnchor.constraint(equalToConstant: 26+increaseIconSize)
		iconNormalHeightConstraint = iconNormal.widthAnchor.constraint(equalToConstant: 26+increaseIconSize)

		iconNormal.contentMode = .scaleAspectFit

		iconNormalWidthConstraint.isActive = true
		iconNormalHeightConstraint.isActive = true

//		baseView.alpha = 0
	}

	// MARK: TinyMapPinAccessoryViewDisplayLogic

	func setAsLevel(_ level: Int) {

//		if(level == isLevel) {
//			return
//		}

//		baseView.fadeTransition(0.3)
//		backgroundImageView.fadeTransition(0.3)
//		iconNormal.fadeTransition(0.3)

		isLevel = level

		let increaseIconSize: CGFloat = CGFloat(max(0, Font.increaseFontSize)) * 2

		if isLevel == 0 {
			self.transform = CGAffineTransform.identity.scaledBy(x: 4/26, y: 4/26)
//			iconNormalWidthConstraint.constant = 4 + increaseIconSize
//			iconNormalHeightConstraint.constant = 4 + increaseIconSize
//			iconLeftConstraint.constant = 1
//			iconTopConstraint.constant = 1
//			iconBottomConstraint.constant = -1
//			iconRightConstraint.constant = -1
		} else if isLevel == 1 {
			self.transform = CGAffineTransform.identity.scaledBy(x: 8/26, y: 8/26)
//			iconNormalWidthConstraint.constant = 8 + increaseIconSize
//			iconNormalHeightConstraint.constant = 8 + increaseIconSize
//			iconLeftConstraint.constant = 2
//			iconTopConstraint.constant = 2
//			iconBottomConstraint.constant = -2
//			iconRightConstraint.constant = -2
		} else if isLevel == 2 {
			self.transform = CGAffineTransform.identity.scaledBy(x: 13/26, y: 13/26)
//			iconNormalWidthConstraint.constant = 14 + increaseIconSize
//			iconNormalHeightConstraint.constant = 14 + increaseIconSize
//			iconLeftConstraint.constant = 3
//			iconTopConstraint.constant = 3
//			iconBottomConstraint.constant = -3
//			iconRightConstraint.constant = -3
		} else if isLevel == 3 {
			self.transform = CGAffineTransform.identity.scaledBy(x: 1, y: 1)
//			iconNormalWidthConstraint.constant = 126 + increaseIconSize
//			iconNormalHeightConstraint.constant = 126 + increaseIconSize
//			iconLeftConstraint.constant = 4
//			iconTopConstraint.constant = 4
//			iconBottomConstraint.constant = -4
//			iconRightConstraint.constant = -4
		} else {
			self.transform = CGAffineTransform.identity.scaledBy(x: 1.5, y: 1.5)
//			iconNormalWidthConstraint.constant = 126 + increaseIconSize
//			iconNormalHeightConstraint.constant = 126 + increaseIconSize
//			iconLeftConstraint.constant = 4
//			iconTopConstraint.constant = 4
//			iconBottomConstraint.constant = -4
//			iconRightConstraint.constant = -4
		}

//		UIView.setAnimationsEnabled(false)
//			self.superview?.frame = self.frame
//			self.superview?.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//		UIView.setAnimationsEnabled(true)
	}
}
