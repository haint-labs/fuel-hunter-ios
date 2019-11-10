//
//  MapInfoButtonView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol MapInfoButtonViewButtonLogic: class {
	func buttonWasPressedForViewType(_ viewType: MapInfoButtonViewType)
}

protocol MapInfoButtonViewDisplayLogic {
    func setAsType(_ type: MapInfoButtonViewType, withText text: String)
}

enum MapInfoButtonViewType: Int {
	case typePrice, typeDistance
}

class MapInfoButtonView: UIView, MapInfoButtonViewDisplayLogic {

	weak var controller: MapInfoButtonViewButtonLogic? 
	var viewType: MapInfoButtonViewType = .typePrice
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var button: UIButton!
	@IBOutlet var iconImageView: UIImageView!
	@IBOutlet var label: UILabel!
	@IBOutlet var accessoryIconImageView: UIImageView!

	var labelRightAnchorConstraint: NSLayoutConstraint?
	var accessoryImageRightAnchorConstraint: NSLayoutConstraint?
	
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
		Bundle.main.loadNibNamed("MapInfoButtonView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true

		button.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false
		accessoryIconImageView.translatesAutoresizingMaskIntoConstraints = false

		button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		button.topAnchor.constraint(equalTo: topAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		iconImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
		iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true

		label.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
		label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
		label.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true 
		labelRightAnchorConstraint = label.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)

		accessoryIconImageView.heightAnchor.constraint(equalToConstant: 13).isActive = true
		accessoryIconImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
		accessoryIconImageView.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 10).isActive = true
		accessoryImageRightAnchorConstraint = accessoryIconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)

		label.isUserInteractionEnabled = false

		button.backgroundColor = .white
		button.layer.borderColor = UIColor.init(named: "TitleColor")?.cgColor
		button.layer.borderWidth = 1
		button.layer.cornerRadius = 6

		label.font = Font.init(.normal, size: .size3).font

		button.addTarget(self, action: NSSelectorFromString("buttonPressed"), for: .touchUpInside)
	}

	// MARK: MapInfoButtonViewDisplayLogic

	func setAsType(_ type: MapInfoButtonViewType, withText text: String) {
		label.text = text
		viewType = type
		if type == .typePrice {
			iconImageView.image = UIImage.init(named: "money_sign")
			accessoryIconImageView.isHidden = true
			accessoryImageRightAnchorConstraint?.isActive = false
			labelRightAnchorConstraint?.isActive = true
		} else {
			if !AppSettingsWorker.shared.getGPSIsEnabled() || text == "-1" {
				label.text = "Directions"
			}
			iconImageView.image = UIImage.init(named: "car_sign")
			accessoryIconImageView.isHidden = false
			accessoryImageRightAnchorConstraint?.isActive = true
			labelRightAnchorConstraint?.isActive = false
		}
	}

	// MARK: MapInfoButtonViewButtonLogic

	@objc func buttonPressed() {
		controller?.buttonWasPressedForViewType(viewType)
	}
}
