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


//		button.translatesAutoresizingMaskIntoConstraints = false
//		iconImageView.translatesAutoresizingMaskIntoConstraints = false
//		label.translatesAutoresizingMaskIntoConstraints = false
//		accessoryIconImageView.translatesAutoresizingMaskIntoConstraints = false
//
//		button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
//		button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//		button.topAnchor.constraint(equalTo: topAnchor).isActive = true
//		button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//
//		iconImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
//		iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//		iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
//
//		label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
//		label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
//		label.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
//		labelRightAnchorConstraint = label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
//
//		accessoryIconImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
//		accessoryIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
//		accessoryIconImageView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
//		accessoryImageRightAnchorConstraint = accessoryIconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
//
//		label.isUserInteractionEnabled = false
//
//		button.backgroundColor = .white
//		button.layer.borderColor = UIColor.init(named: "TitleColor")?.cgColor
//		button.layer.borderWidth = 1
//		button.layer.cornerRadius = 6
//
//		label.font = Font.init(.normal, size: .size3).font
//
//		button.addTarget(self, action: NSSelectorFromString("buttonPressed"), for: .touchUpInside)
	}
}
