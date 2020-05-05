//
//  LoadedCityExplainLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol LoadedCityExplainLayoutViewLogic: class {
	func doneButtonPressed()
}

protocol LoadedCityExplainLayoutViewDataLogic: class {
	func animateBackgroundImageColorToState(visible: Bool)
	func updateData(data: LoadedCity.Data.ViewModel)
}

class LoadedCityExplainLayoutView: FontChangeView, LoadedCityExplainLayoutViewDataLogic {

	weak var controller: LoadedCityExplainLayoutViewLogic?

	@IBOutlet var backgroundDismissButton: UIButton!
	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontViewContainer: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var doneButton: UIButton!

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
		Bundle.main.loadNibNamed("LoadedCityExplainLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		frontViewContainer.backgroundColor = .clear
		baseView.backgroundColor = .clear

		self.translatesAutoresizingMaskIntoConstraints = false
		frontViewContainer.translatesAutoresizingMaskIntoConstraints = false
		frontView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
  		baseView.translatesAutoresizingMaskIntoConstraints = false
  		titleLabel.translatesAutoresizingMaskIntoConstraints = false
  		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
  		doneButton.translatesAutoresizingMaskIntoConstraints = false
		backgroundDismissButton.translatesAutoresizingMaskIntoConstraints = false

  		baseView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

  		backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 6000).isActive = true
  		backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3000).isActive = true

		frontViewContainer.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		frontViewContainer.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		backgroundDismissButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundDismissButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		backgroundDismissButton.addTarget(self, action: NSSelectorFromString("doneButtonPressed"), for: .touchUpInside)

  		titleLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 20).isActive = true
  		titleLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
  		titleLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true

  		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
  		descriptionLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
  		descriptionLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true

  		doneButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20).isActive = true
  		doneButton.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
  		doneButton.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true
  		doneButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

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

  		titleLabel.font = Font(.medium, size: .size1).font
  		descriptionLabel.font = Font(.normal, size: .size3).font
  		doneButton.setTitle("ok_button_title".localized(), for: .normal)
  		doneButton.titleLabel?.font = Font(.medium, size: .size2).font

  		backgroundView.backgroundColor = .clear
  		doneButton.addTarget(self, action: NSSelectorFromString("doneButtonPressed"), for: .touchUpInside)
	}

  	// MARK: Functions

  	@objc private func doneButtonPressed() {
  		controller?.doneButtonPressed()
  	}

	override func fontSizeWasChanged() {
		doneButtonPressed()
	}

	// MARK: LoadedCityExplainLayoutViewDataLogic

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

	func updateData(data: LoadedCity.Data.ViewModel) {
		titleLabel.text = "\("fuel_list_city_title".localized()) \(data.cityName.localized())?"
		descriptionLabel.text = "fuel_list_city_explain_description".localized()
	}
}
