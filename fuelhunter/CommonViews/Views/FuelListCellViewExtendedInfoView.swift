//
//  FuelListCellViewExtendedInfoView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import ActiveLabel

protocol FuelListCellViewExtendedInfoViewDisplayLogic {
    func updateData()
}

protocol FuelListCellViewExtendedInfoViewButtonLogic: class {
    func userPressedOnHomePageButton()
}

class FuelListCellViewExtendedInfoView: UIView, FuelListCellViewExtendedInfoViewDisplayLogic {

	// Forward this from viewController, so that we can extend white bg on the bottom
	var safeLayoutBottomInset: CGFloat = 0 {
		didSet {
//			self.extendedDescriptionLabelBottomConstraint?.constant = -safeLayoutBottomInset
		}
	}
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var extendedDescriptionLabel: ActiveLabel!

	weak var controller: FuelListCellViewExtendedInfoViewButtonLogic?

	var extendedDescriptionLabelBottomConstraint: NSLayoutConstraint?
		
	
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
		Bundle.main.loadNibNamed("FuelListCellViewExtendedInfoView", owner: self, options: nil)
		addSubview(baseView)
//		self.backgroundColor = .blue
		baseView.frame = self.bounds
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false

		baseView.translatesAutoresizingMaskIntoConstraints = false
		extendedDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false

        baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
       	baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
       	baseView.backgroundColor = .clear

       	extendedDescriptionLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
		extendedDescriptionLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
		extendedDescriptionLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
		extendedDescriptionLabelBottomConstraint = extendedDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		//===
		
				
		extendedDescriptionLabel.font = Font(.normal, size: .size5).font

		extendedDescriptionLabelBottomConstraint?.isActive = true
	}
	
	// MARK: Functions

	// MARK: FuelListCellViewExtendedInfoViewDisplayLogic

	func updateData() {

		let patternString = "\\s\("map_price_last_updated_homepage_name".localized())\\b"
		var lastUpdatedString = "map_price_last_was_updated_many_ago_text".localized()
		lastUpdatedString = lastUpdatedString.replacingOccurrences(of: "^^^", with: "45")

//		lastUpdatedString.append("\n\nAA\nAAA\n\n\nAAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA\n\nAAA")
		let customType = ActiveType.custom(pattern: patternString)
		extendedDescriptionLabel.enabledTypes = [customType]
		extendedDescriptionLabel.text = lastUpdatedString
		extendedDescriptionLabel.customColor[customType] = UIColor(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
		extendedDescriptionLabel.customSelectedColor[customType] = UIColor(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
    	extendedDescriptionLabel.handleCustomTap(for: customType) { element in 
//			print("Custom type tapped: \(element)")
			self.controller?.userPressedOnHomePageButton()
		}

		self.setNeedsLayout()
	}
}
