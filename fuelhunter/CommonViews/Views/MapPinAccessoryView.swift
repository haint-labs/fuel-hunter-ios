//
//  MapPinAccessoryView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit


class MapPinAccessoryView: UIView {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var backgroundBubbleArrowImageView: UIImageView!
	@IBOutlet var iconGray: UIImageView!
	@IBOutlet var iconNormal: UIImageView!
	@IBOutlet var priceLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!

	var priceLabelBottomConstraint: NSLayoutConstraint!
	var distanceLabelBottomConstraint: NSLayoutConstraint!
	var iconGrayBottomConstraint: NSLayoutConstraint!
	var iconNormalBottomConstraint: NSLayoutConstraint!

	var address: String!
	var title: String!
	
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
		Bundle.main.loadNibNamed("MapPinAccessoryView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		// For icons. We need to compensate, so that it would nice, when showing price + distance.
		let increaseIconSize: CGFloat = CGFloat(max(0, Font.increaseFontSize)) * 2

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundBubbleArrowImageView.translatesAutoresizingMaskIntoConstraints = false
		iconGray.translatesAutoresizingMaskIntoConstraints = false
		iconNormal.translatesAutoresizingMaskIntoConstraints = false
		priceLabel.translatesAutoresizingMaskIntoConstraints = false
		distanceLabel.translatesAutoresizingMaskIntoConstraints = false


		baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		backgroundImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3.5).isActive = true

		backgroundBubbleArrowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		backgroundBubbleArrowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true

		backgroundBubbleArrowImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		iconGray.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
		iconGray.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
		iconGray.widthAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		iconGray.heightAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		iconGrayBottomConstraint = iconGray.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
		iconGrayBottomConstraint?.priority = .defaultHigh
		iconGrayBottomConstraint?.isActive = true

		iconNormal.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
		iconNormal.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
		iconNormal.widthAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		iconNormal.heightAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		iconNormalBottomConstraint = iconNormal.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
		iconNormalBottomConstraint?.priority = .defaultHigh
		iconNormalBottomConstraint?.isActive = true


		priceLabel.leftAnchor.constraint(equalTo: iconGray.rightAnchor, constant: 5).isActive = true
		priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
		priceLabelBottomConstraint = priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)


		distanceLabel.leftAnchor.constraint(equalTo: iconGray.rightAnchor, constant: 5).isActive = true
		distanceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -1).isActive = true
		distanceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
		distanceLabelBottomConstraint = distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
		distanceLabelBottomConstraint.isActive = true

		priceLabel.font = Font(.medium, size: .size3).font
		distanceLabel.font = Font(.normal, size: .size5).font
	}

	func setAsSelected(_ selected: Bool, isCheapestPrice: Bool) {
		if selected == true {
			priceLabel.textColor = UIColor(named: isCheapestPrice ? "CheapPriceColor" : "TitleColor")
			distanceLabel.textColor = UIColor(named: "SubTitleColor")
			iconGray.isHidden = true
			iconNormal.isHidden = false
		} else {
			priceLabel.textColor = UIColor(named: "InactiveTextColor")
			distanceLabel.textColor = UIColor(named: "InactiveTextColor")
			iconGray.isHidden = false
			iconNormal.isHidden = true
		}
	}

	func setDistanceVisible(_ visible: Bool) {

		baseView.fadeTransition(0.2)
		backgroundImageView.fadeTransition(0.2)
		backgroundBubbleArrowImageView.fadeTransition(0.2)
		priceLabel.fadeTransition(0.2)
		distanceLabel.fadeTransition(0.2)
		iconGray.fadeTransition(0.2)
		iconNormal.fadeTransition(0.2)
		
		if visible == true {
			distanceLabel.isHidden = false
			priceLabelBottomConstraint.isActive = false
			distanceLabelBottomConstraint.isActive = true
		} else {
			distanceLabel.isHidden = true
			distanceLabelBottomConstraint.isActive = false
			priceLabelBottomConstraint.isActive = true
		}
	}
}
