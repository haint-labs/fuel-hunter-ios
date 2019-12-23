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
	@IBOutlet var icon: UIImageView!
	@IBOutlet var priceLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!

	var priceLabelBottomConstraint: NSLayoutConstraint!
	var distanceLabelBottomConstraint: NSLayoutConstraint!
	var iconBottomConstraint: NSLayoutConstraint!

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
		icon.translatesAutoresizingMaskIntoConstraints = false
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

		icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 7).isActive = true
		icon.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
		icon.widthAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		icon.heightAnchor.constraint(equalToConstant: 28+increaseIconSize).isActive = true
		iconBottomConstraint = icon.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10)
		iconBottomConstraint?.priority = .defaultHigh
		iconBottomConstraint?.isActive = true

		priceLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
		priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
		priceLabelBottomConstraint = priceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7)


		distanceLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
		distanceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -1).isActive = true
		distanceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
		distanceLabelBottomConstraint = distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
		distanceLabelBottomConstraint.isActive = true

		priceLabel.font = Font(.medium, size: .size3).font
		distanceLabel.font = Font(.normal, size: .size5).font
	}

	func setAsSelected(_ selected: Bool) {
		if selected == true {
			priceLabel.textColor = UIColor(named: "TitleColor")
			distanceLabel.textColor = UIColor(named: "SubTitleColor")
			icon.isHighlighted = true
		} else {
			priceLabel.textColor = UIColor(named: "InactiveTextColor")
			distanceLabel.textColor = UIColor(named: "InactiveTextColor")
			icon.isHighlighted = false
		}
	}

	func setDistanceVisible(_ visible: Bool) {
		if visible == true {
			distanceLabel.isHidden = false
//			iconBottomConstraint.isActive = false
			priceLabelBottomConstraint.isActive = false
			distanceLabelBottomConstraint.isActive = true
		} else {
			distanceLabel.isHidden = true
			distanceLabelBottomConstraint.isActive = false
//			iconBottomConstraint.isActive = true
			priceLabelBottomConstraint.isActive = true
		}
	}
}
