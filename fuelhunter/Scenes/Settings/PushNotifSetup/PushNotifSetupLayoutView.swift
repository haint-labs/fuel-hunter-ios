//
//  PushNotifSetupLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol PushNotifSetupLayoutViewLogic: class {
	func activateButtonPressed()
	func cancelButtonPressed()
	func stepperPressed(value: Int)
}

protocol PushNotifSetupLayoutViewDataLogic: class {
	func updateData(data: PushNotifSetup.SetUp.ViewModel)
}

class PushNotifSetupLayoutView: UIView, PushNotifSetupLayoutViewDataLogic {

	weak var controller: PushNotifSetupLayoutViewLogic? 

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet weak var notifAnimationView: NotifPhoneAnimationView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var stepper: UIStepper!
	@IBOutlet weak var activateButton: UIButton!
	@IBOutlet weak var cancelButton: UIButton!

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
		Bundle.main.loadNibNamed("PushNotifSetupLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		baseView.backgroundColor = .clear

		self.translatesAutoresizingMaskIntoConstraints = false
		frontView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
  		baseView.translatesAutoresizingMaskIntoConstraints = false
  		notifAnimationView.translatesAutoresizingMaskIntoConstraints = false
  		titleLabel.translatesAutoresizingMaskIntoConstraints = false
  		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
  		stepper.translatesAutoresizingMaskIntoConstraints = false
  		activateButton.translatesAutoresizingMaskIntoConstraints = false
  		cancelButton.translatesAutoresizingMaskIntoConstraints = false

  		baseView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

  		backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 6000).isActive = true
  		backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3000).isActive = true

  		notifAnimationView.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 20).isActive = true
  		notifAnimationView.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
  		notifAnimationView.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true

  		titleLabel.topAnchor.constraint(equalTo: notifAnimationView.bottomAnchor, constant: 10).isActive = true
  		titleLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 30).isActive = true
  		titleLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -30).isActive = true

  		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
  		descriptionLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 30).isActive = true
  		descriptionLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -30).isActive = true

  		stepper.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30).isActive = true
  		stepper.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true

  		activateButton.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 30).isActive = true
  		activateButton.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 40).isActive = true
  		activateButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

  		cancelButton.topAnchor.constraint(equalTo: stepper.bottomAnchor, constant: 30).isActive = true
  		cancelButton.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -40).isActive = true
  		cancelButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

		frontView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 20).isActive = true
  		let yconstraint = frontView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -50)
		yconstraint.priority = .defaultLow
		yconstraint.isActive = true
  		frontView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
  		frontView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true

  		frontView.backgroundColor = .white
  		frontView.layer.cornerRadius = 10
  		frontView.layer.shadowColor = UIColor(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 0.44).cgColor
  		frontView.layer.shadowOpacity = 1
  		frontView.layer.shadowRadius = 8

  		titleLabel.font = Font(.medium, size: .size1).font
  		descriptionLabel.font = Font(.normal, size: .size2).font
  		activateButton.setTitle("activate_button_title".localized(), for: .normal)
  		activateButton.titleLabel?.font = Font(.medium, size: .size2).font
  		cancelButton.setTitle("cancel_button_title".localized(), for: .normal)
  		cancelButton.titleLabel?.font = Font(.medium, size: .size2).font
  		backgroundView.backgroundColor = .clear
  		activateButton.addTarget(self, action: NSSelectorFromString("activateButtonPressed"), for: .touchUpInside)
  		cancelButton.addTarget(self, action: NSSelectorFromString("cancelButtonPressed"), for: .touchUpInside)
  		stepper.addTarget(self, action:NSSelectorFromString("stepperPressed"), for: .valueChanged)
  	}

  	// MARK: Functions

  	@objc func activateButtonPressed() {
  		controller?.activateButtonPressed()
  	}

  	@objc func cancelButtonPressed() {
  		controller?.cancelButtonPressed()
  	}

  	@objc func stepperPressed() {
		controller?.stepperPressed(value: Int(stepper.value))
  	}

  	func appMovedToForeground() {
  		notifAnimationView.startAnimating()
	}

	func appMovedToBackground() {
		notifAnimationView.stopAnimating()
	}

	func animateBackgroundImageColorToState(visible: Bool) {
		if visible {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = UIColor(red: 46/255.0, green: 63/255.0, blue: 97/255.0, alpha: 0.3)
			}, completion: { (finished: Bool) in })
		} else {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = .clear
			}, completion: { (finished: Bool) in })
		}
	}

	// MARK: PushNotifSetupLayoutViewDataLogic

	func updateData(data: PushNotifSetup.SetUp.ViewModel) {
		titleLabel.text = "intro_notifs_title".localized()
		descriptionLabel.text = data.displayedItem.description
  		stepper.minimumValue = Double(data.displayedItem.minValue)
  		stepper.maximumValue = Double(data.displayedItem.maxValue)
  		stepper.value = Double(data.displayedItem.value)
	}
}
