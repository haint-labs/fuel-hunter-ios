//
//  MapPinAccessoryView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit


class MapPinAccessoryView: UIView {

//	weak var controller: MapInfoButtonViewButtonLogic?
//	var viewType: MapInfoButtonViewType = .typePrice

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var backgroundImageView: UIImageView!
	@IBOutlet var backgroundBubbleArrowImageView: UIImageView!
	@IBOutlet var icon: UIImageView!
	@IBOutlet var priceLabel: UILabel!
	@IBOutlet var distanceLabel: UILabel!
	
//	@IBOutlet var button: UIButton!
//	@IBOutlet var iconImageView: UIImageView!
//	@IBOutlet var label: UILabel!
//	@IBOutlet var accessoryIconImageView: UIImageView!

//	var labelRightAnchorConstraint: NSLayoutConstraint?
//	var accessoryImageRightAnchorConstraint: NSLayoutConstraint?

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
		icon.widthAnchor.constraint(equalToConstant: 28).isActive = true
		icon.heightAnchor.constraint(equalToConstant: 28).isActive = true
	

		priceLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
		priceLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true


		distanceLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5).isActive = true
		distanceLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: -1).isActive = true
		distanceLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -7).isActive = true
		distanceLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -7).isActive = true


		priceLabel.font = Font.init(.medium, size: .size3).font
		distanceLabel.font = Font.init(.normal, size: .size5).font
	}

	func setAsSelected(_ selected: Bool) {
		if selected == true {
			priceLabel.textColor = UIColor.init(named: "TitleColor")
			distanceLabel.textColor = UIColor.init(named: "SubTitleColor")
			icon.isHighlighted = true
//			icon.alpha = 1
		} else {
			priceLabel.textColor = UIColor.init(named: "InactiveTextColor")
			distanceLabel.textColor = UIColor.init(named: "InactiveTextColor")
			icon.isHighlighted = false
//			icon.alpha = 0.5
		}
	}
}
