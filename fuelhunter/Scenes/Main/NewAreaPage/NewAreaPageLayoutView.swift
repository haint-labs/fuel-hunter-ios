//
//  NewAreaPageLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol NewAreaPageLayoutViewLogic: class {
	func setUpButtonPressed()
}

protocol NewAreaPageLayoutViewDataLogic: class {
	func updateData()
}

class NewAreaPageLayoutView: FontChangeView, NewAreaPageLayoutViewDataLogic {

	weak var controller: NewAreaPageLayoutViewLogic?

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var setUpButton: UIButton!
	@IBOutlet var cityNameView: ClosestCityNameButtonView!
	@IBOutlet var backgroundImageView: UIImageView!

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	private func setup() {
		Bundle.main.loadNibNamed("NewAreaPageLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		baseView.backgroundColor = .clear

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		cityNameView.translatesAutoresizingMaskIntoConstraints = false
  		titleLabel.translatesAutoresizingMaskIntoConstraints = false
  		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
  		setUpButton.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.contentMode = .scaleToFill

		cityNameView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		cityNameView.topAnchor.constraint(equalTo: topAnchor).isActive = true

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		backgroundImageView.topAnchor.constraint(equalTo: cityNameView.bottomAnchor, constant: 52).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: setUpButton.bottomAnchor, constant: 20).isActive = true


  		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 20).isActive = true
  		titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
  		titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true

  		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
  		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
  		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true

  		setUpButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
  		setUpButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
  		setUpButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
//  		setUpButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

  		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
  		
  		updateFonts()

		backgroundImageView.image = UIImage(named: "cell_bg_single")
		
  		setUpButton.addTarget(self, action: NSSelectorFromString("setUpButtonPressed"), for: .touchUpInside)
	}

  	// MARK: Functions

  	@objc private func setUpButtonPressed() {
  		controller?.setUpButtonPressed()
  	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size1).font
  		descriptionLabel.font = Font(.normal, size: .size3).font
  		setUpButton.setTitle("Uzstādīt".localized(), for: .normal)
  		setUpButton.titleLabel?.font = Font(.medium, size: .size2).font
	}

	// MARK: NewAreaPageLayoutViewDataLogic

	func updateData() {
		_ = cityNameView.setCity(name: "Jauna vieta".localized(), gpsIconVisible: false)
		titleLabel.text = "Seko līdzi degvielas cenām citur Latvijā".localized()
		descriptionLabel.text = "Parasti uzpildies noteiktā vietā Latvijā?\n\nDod priekšroku noteiktām degvielas uzpildes stacijām?".localized()
//		self.setNeedsLayout()
	}
}
