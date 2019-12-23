//
//  AboutAppTableHeaderView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AboutAppTableHeaderView: FontChangeView {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var mapPreviewView: MapAnimationView!
	@IBOutlet weak var mapLabel: UILabel!
	@IBOutlet weak var notifPhoneAnimationView: NotifPhoneAnimationView!
	@IBOutlet weak var notifLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var descriptionLabel: UILabel!

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
		Bundle.main.loadNibNamed("AboutAppTableHeaderView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		mapPreviewView.translatesAutoresizingMaskIntoConstraints = false
		mapLabel.translatesAutoresizingMaskIntoConstraints = false
		notifPhoneAnimationView.translatesAutoresizingMaskIntoConstraints = false
		notifLabel.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false

		mapPreviewView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		mapPreviewView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true

		mapLabel.topAnchor.constraint(equalTo: mapPreviewView.bottomAnchor, constant: 10).isActive = true
		mapLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
		mapLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true

		notifPhoneAnimationView.topAnchor.constraint(equalTo: mapLabel.bottomAnchor, constant: 30).isActive = true
		notifPhoneAnimationView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		
		notifLabel.topAnchor.constraint(equalTo: notifPhoneAnimationView.bottomAnchor, constant: 10).isActive = true
		notifLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
		notifLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: notifLabel.bottomAnchor, constant: 30).isActive = true
		separatorView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
		separatorView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true

		descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -16).isActive = true
		descriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -25).isActive = true

		mapLabel.text = "settings_about_app_map_title".localized()
		notifLabel.text = "settings_about_app_notif_title".localized()
		descriptionLabel.text = "settings_about_app_full_description".localized()

		startAnimations()

  		updateFonts()
    }

	func updateFonts() {
		mapLabel.font = Font(.normal, size: .size3).font
		notifLabel.font = Font(.normal, size: .size3).font
		descriptionLabel.font = Font(.normal, size: .size3).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

  	func startAnimations() {
  		mapPreviewView.startAnimating()
		notifPhoneAnimationView.startAnimating()
  	}

  	func stopAnimations() {
		mapPreviewView.layer.removeAllAnimations()
		mapPreviewView.layoutIfNeeded()
		notifPhoneAnimationView.layer.removeAllAnimations()
		notifPhoneAnimationView.layoutIfNeeded()
  	}
}
