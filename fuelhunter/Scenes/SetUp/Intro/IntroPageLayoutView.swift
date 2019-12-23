//
//  IntroPageLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol IntroPageLayoutViewLogic {
	func nextButtonWasPressed()
}

class IntroPageLayoutView: FontChangeView {

	weak var controller: IntroPageViewController? 

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var topTitleLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var description1Label: UILabel!
	@IBOutlet weak var description2Label: UILabel!
	@IBOutlet weak var nextButton: UIButton!

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
		Bundle.main.loadNibNamed("IntroPageLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		iconImageView.translatesAutoresizingMaskIntoConstraints = false
		description1Label.translatesAutoresizingMaskIntoConstraints = false
		description2Label.translatesAutoresizingMaskIntoConstraints = false
		nextButton.translatesAutoresizingMaskIntoConstraints = false

		let space1 = UILayoutGuide()
		self.addLayoutGuide(space1)
		let space1HeightAnchor = space1.heightAnchor.constraint(equalToConstant: 40)
		space1HeightAnchor.priority = .init(rawValue: 500)
		space1HeightAnchor.isActive = true

		let space2 = UILayoutGuide()
		self.addLayoutGuide(space2)
		let space2HeightAnchor = space2.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space2HeightAnchor.priority = .init(rawValue: 500)
		space2HeightAnchor.isActive = true

		let space3 = UILayoutGuide()
		self.addLayoutGuide(space3)
		let space3HeightAnchor = space3.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space3HeightAnchor.priority = .init(rawValue: 500)
		space3HeightAnchor.isActive = true

		let space4 = UILayoutGuide()
		self.addLayoutGuide(space4)
		let space4HeightAnchor = space4.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space4HeightAnchor.priority = .init(rawValue: 500)
		space4HeightAnchor.isActive = true

		let space5 = UILayoutGuide()
		self.addLayoutGuide(space5)
		let space5HeightAnchor = space5.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 2.5)
		space5HeightAnchor.priority = .init(rawValue: 500)
		space5HeightAnchor.isActive = true

		let space6 = UILayoutGuide()
		self.addLayoutGuide(space6)
		let space6HeightAnchor = space6.heightAnchor.constraint(equalTo: space1.heightAnchor, multiplier: 1.25)
		space6HeightAnchor.priority = .init(rawValue: 1)
		space6HeightAnchor.isActive = true

		space1.topAnchor.constraint(equalTo: topAnchor).isActive = true

		topTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		topTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		topTitleLabel.topAnchor.constraint(equalTo: space1.bottomAnchor).isActive = true

		space2.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor).isActive = true

		iconImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		iconImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		iconImageView.topAnchor.constraint(equalTo: space2.bottomAnchor).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 106).isActive = true

		space3.topAnchor.constraint(equalTo: iconImageView.bottomAnchor).isActive = true

		description1Label.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		description1Label.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		description1Label.topAnchor.constraint(equalTo: space3.bottomAnchor).isActive = true

		space4.topAnchor.constraint(equalTo: description1Label.bottomAnchor).isActive = true

		description2Label.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		description2Label.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		description2Label.topAnchor.constraint(equalTo: space4.bottomAnchor).isActive = true

		space5.topAnchor.constraint(equalTo: description2Label.bottomAnchor).isActive = true
		space6.topAnchor.constraint(equalTo: space5.bottomAnchor).isActive = true

		nextButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		nextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		nextButton.topAnchor.constraint(equalTo: space6.bottomAnchor).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true

		topTitleLabel.text = "Fuel\nHunter"
		description1Label.text = "intro_app_description_text_1".localized()
		description2Label.text = "intro_app_description_text_2".localized()
		nextButton.setTitle("next_button_title".localized(), for: .normal)
		nextButton.addTarget(self, action:NSSelectorFromString("nextButtonPressed"), for: .touchUpInside)

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

  		updateFonts()
    }

	func updateFonts() {
		iconImageView.image = UIImage(named: "Intro_icon")
		topTitleLabel.font = Font(.normal, size: .size0).font
		description1Label.font = Font(.normal, size: .size2).font
		description2Label.font = Font(.normal, size: .size2).font
		nextButton.titleLabel?.font = Font(.medium, size: .size2).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

	// MARK: Functions

  	@objc func nextButtonPressed() {
		controller?.nextButtonWasPressed()
  	}	
}
