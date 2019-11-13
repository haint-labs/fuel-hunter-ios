//
//  AppSavingsView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AppSavingsView: UIView {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var savingsIcon1: UIImageView!
	@IBOutlet weak var savingsIcon2: UIImageView!
	@IBOutlet weak var savingsIcon3: UIImageView!
	@IBOutlet weak var savingsIcon4: UIImageView!
	@IBOutlet weak var savingsLabel1: UILabel!
	@IBOutlet weak var savingsLabel2: UILabel!
	@IBOutlet weak var savingsLabel3: UILabel!
	@IBOutlet weak var savingsLabel4: UILabel!
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
		Bundle.main.loadNibNamed("AppSavingsView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		baseView.backgroundColor = .blue
		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon1.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon2.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon3.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon4.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel1.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel2.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel3.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel4.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false

		savingsIcon1.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon1.heightAnchor.constraint(equalTo: savingsIcon1.widthAnchor).isActive = true
		savingsIcon1.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
		savingsIcon1.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel1.leftAnchor.constraint(equalTo: savingsIcon1.rightAnchor, constant: 16).isActive = true
		savingsLabel1.topAnchor.constraint(equalTo: topAnchor).isActive = true
		savingsLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		savingsIcon2.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon2.heightAnchor.constraint(equalTo: savingsIcon2.widthAnchor).isActive = true
		savingsIcon2.topAnchor.constraint(equalTo: savingsLabel1.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon2.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel2.leftAnchor.constraint(equalTo: savingsIcon2.rightAnchor, constant: 16).isActive = true
		savingsLabel2.topAnchor.constraint(equalTo: savingsLabel1.bottomAnchor, constant: 16).isActive = true
		savingsLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		savingsIcon3.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon3.heightAnchor.constraint(equalTo: savingsIcon3.widthAnchor).isActive = true
		savingsIcon3.topAnchor.constraint(equalTo: savingsLabel2.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon3.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel3.leftAnchor.constraint(equalTo: savingsIcon3.rightAnchor, constant: 16).isActive = true
		savingsLabel3.topAnchor.constraint(equalTo: savingsLabel2.bottomAnchor, constant: 16).isActive = true
		savingsLabel3.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		savingsIcon4.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon4.heightAnchor.constraint(equalTo: savingsIcon4.widthAnchor).isActive = true
		savingsIcon4.topAnchor.constraint(equalTo: savingsLabel3.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon4.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel4.leftAnchor.constraint(equalTo: savingsIcon4.rightAnchor, constant: 16).isActive = true
		savingsLabel4.topAnchor.constraint(equalTo: savingsLabel3.bottomAnchor, constant: 16).isActive = true
		savingsLabel4.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: savingsLabel4.bottomAnchor, constant: 30).isActive = true
		separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true

		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true

		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		savingsLabel1.font = Font.init(.normal, size: .size3).font
		savingsLabel2.font = Font.init(.normal, size: .size3).font
		savingsLabel3.font = Font.init(.normal, size: .size3).font
		savingsLabel4.font = Font.init(.normal, size: .size3).font
		descriptionLabel.font = Font.init(.normal, size: .size3).font

		savingsLabel1.text = "fuel_savings_description_1".localized()
		savingsLabel2.text = "fuel_savings_description_2".localized()
		savingsLabel3.text = "fuel_savings_description_3".localized()
		savingsLabel4.text = "fuel_savings_description_4".localized()
		descriptionLabel.text = "fuel_savings_description_5".localized()
  	}
}
