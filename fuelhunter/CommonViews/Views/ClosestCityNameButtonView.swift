//
//  ClosestCityNameButtonView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol ClosestCityNameButtonViewButtonLogic: class {
	func closestCityNameButtonWasPressed()
}

protocol ClosestCityNameButtonViewDisplayLogic {
    func setCity(name: String, gpsIconVisible: Bool) -> Bool
}

class ClosestCityNameButtonView: FontChangeView, ClosestCityNameButtonViewDisplayLogic {

	weak var controller: ClosestCityNameButtonViewButtonLogic?

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var button: UIButton!
	@IBOutlet var iconImageView: UIImageView!
	@IBOutlet var label: UILabel!
	
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
		Bundle.main.loadNibNamed("ClosestCityNameButtonView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true
		self.backgroundColor = .clear

		button.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		label.translatesAutoresizingMaskIntoConstraints = false

		button.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		button.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		button.topAnchor.constraint(equalTo: topAnchor).isActive = true
		button.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		iconImageView.heightAnchor.constraint(equalToConstant: 9).isActive = true
		iconImageView.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 1).isActive = true
		iconImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true

		label.topAnchor.constraint(equalTo: topAnchor, constant: 14).isActive = true
		label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		label.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 5).isActive = true
		label.rightAnchor.constraint(equalTo: rightAnchor, constant: -14).isActive = true

		label.isUserInteractionEnabled = false

		updateFonts()

		button.addTarget(self, action: NSSelectorFromString("buttonPressed"), for: .touchUpInside)
		button.backgroundColor = .clear
	}

	// MARK: ClosestCityNameButtonViewDisplayLogic

	func setCity(name: String, gpsIconVisible: Bool) -> Bool {
		if self.label.text == name && gpsIconVisible != self.iconImageView.isHidden {
			// No change!
			return false
		}

		self.label.text = name
		self.iconImageView.isHidden = !gpsIconVisible
		return true
	}

	// MARK: Functions

	@objc private func buttonPressed() {
		controller?.closestCityNameButtonWasPressed()
	}

	private func updateFonts() {
		label.font = Font(.normal, size: .size3).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}
}
