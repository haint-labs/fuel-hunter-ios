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
    func updateData(dateTimestamp: Double, priceWasFromHomepage: Bool, textHidden: Bool)
}

protocol FuelListCellViewExtendedInfoViewButtonLogic: class {
    func userPressedOnHomePageButton()
}

class FuelListCellViewExtendedInfoView: UIView, FuelListCellViewExtendedInfoViewDisplayLogic {

	// Forward this from viewController, so that we can extend white bg on the bottom
	var safeLayoutBottomInset: CGFloat = 0
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var extendedDescriptionLabel: ActiveLabel!

	weak var controller: FuelListCellViewExtendedInfoViewButtonLogic?

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
		Bundle.main.loadNibNamed("FuelListCellViewExtendedInfoView", owner: self, options: nil)
		addSubview(baseView)

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
		extendedDescriptionLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		//===

		extendedDescriptionLabel.font = Font(.normal, size: .size5).font
	}

	// MARK: FuelListCellViewExtendedInfoViewDisplayLogic

	func updateData(dateTimestamp: Double, priceWasFromHomepage: Bool, textHidden: Bool) {
		if textHidden == true {
			extendedDescriptionLabel.text = ""
			return
		}

		let calendar = Calendar.current
		let date = Date(timeIntervalSince1970: dateTimestamp)


		let patternString = "\\s\("map_price_last_updated_homepage_name".localized())\\b"
		var lastUpdatedString = ""

		let timestamp = dateTimestamp//PricesDownloader.lastDownloadTimeStamp()

		if timestamp == 0 {
			lastUpdatedString = "map_price_last_was_updated_more_than_a_day_ago_text".localized()
		} else {
			let diffSeconds = Int(Date().timeIntervalSince1970 - timestamp)

			let minutes = diffSeconds / 60
			let hours = diffSeconds / 3600

			if calendar.isDateInYesterday(date) {
				let hour = calendar.component(.hour, from: date)
				let minutes = calendar.component(.minute, from: date)
				lastUpdatedString = "map_price_last_updated_yesterday".localized()
				lastUpdatedString = lastUpdatedString.replacingOccurrences(of: "^^^", with: "\(hour):\(minutes)")
			}
			else {
				if hours == 1 { // Hour
					lastUpdatedString = "map_price_was_updated_hour_ago_text".localized()
				} else if hours >= 24 { // Too old data..
					lastUpdatedString = "map_price_last_was_updated_more_than_a_day_ago_text".localized()
				} else if hours > 1 { // Hours
					lastUpdatedString = "map_price_last_was_updated_many_hours_ago_text".localized()
					lastUpdatedString = lastUpdatedString.replacingOccurrences(of: "^^^", with: "\(hours)")
				} else if minutes <= 1 { // Just now
					lastUpdatedString = "map_price_last_was_updated_just_ago_text".localized()
				} else { // Minutes (until 59
					lastUpdatedString = "map_price_last_was_updated_many_minutes_ago_text".localized()
					lastUpdatedString = lastUpdatedString.replacingOccurrences(of: "^^^", with: "\(minutes)")
				}
			}
		}

		if !priceWasFromHomepage {
			lastUpdatedString.append("\n\("map_price_was_updated_from_waze".localized())")
		} else {
			lastUpdatedString.append("\n\("map_price_was_updated_from_homepage".localized())")
		}

		let customType = ActiveType.custom(pattern: patternString)
		extendedDescriptionLabel.enabledTypes = [customType]
		extendedDescriptionLabel.text = lastUpdatedString
		extendedDescriptionLabel.customColor[customType] = UIColor(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
		extendedDescriptionLabel.customSelectedColor[customType] = UIColor(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
    	extendedDescriptionLabel.handleCustomTap(for: customType) { element in 
			self.controller?.userPressedOnHomePageButton()
		}

		self.setNeedsLayout()
	}
}
