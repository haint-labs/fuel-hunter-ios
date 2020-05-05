//
//  ChooseCityCell.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol ChooseCityCellDisplayLogic {
    func setAsCellType(cellType: CellBackgroundType)
    func setDistance(value: Double, visible: Bool)
    func setText(text: String, with searchString: String?)
}

class ChooseCityCell: FontChangeTableViewCell, ChooseCityCellDisplayLogic {

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var gpsIconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var distanceLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!

	var titleRightDistanceAnchorConstraint: NSLayoutConstraint!
	var titleRightImageAnchorConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        gpsIconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bgViewBottomAnchorConstraint.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		bgViewTopAnchorConstraint.isActive = true

		gpsIconImageView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		gpsIconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 10).isActive = true
		gpsIconImageView.widthAnchor.constraint(equalToConstant: 12).isActive = true
		gpsIconImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11).isActive = true

		distanceLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 8).isActive = true
		distanceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		distanceLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11).isActive = true


		titleRightDistanceAnchorConstraint = titleLabel.rightAnchor.constraint(equalTo: distanceLabel.leftAnchor, constant: -10)
		titleRightImageAnchorConstraint = titleLabel.rightAnchor.constraint(equalTo: gpsIconImageView.leftAnchor, constant: -10)


		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 8).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

    	updateFonts()
    }

    // MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.normal, size: .size2).font
		distanceLabel.font = Font(.normal, size: .size3).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// MARK: ChooseCityCellDisplayLogic

	func setAsCellType(cellType: CellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint.constant = 5
				self.bgViewBottomAnchorConstraint.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_top")
			case .bottom:
				self.bgViewTopAnchorConstraint.constant = 0
				self.bgViewBottomAnchorConstraint.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_bottom")
			case .middle:
				self.bgViewTopAnchorConstraint.constant = 0
				self.bgViewBottomAnchorConstraint.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_middle")
			case .single:
				self.bgViewTopAnchorConstraint.constant = 5
				self.bgViewBottomAnchorConstraint.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_single")
			default:
				break
		}
	}

	func setDistance(value: Double, visible: Bool) {
		if visible == false {
			gpsIconImageView.isHidden = true
			distanceLabel.isHidden = true
		} else {
			if value <= 0 {
				titleRightDistanceAnchorConstraint.isActive = false
				titleRightImageAnchorConstraint.isActive = true
				gpsIconImageView.isHidden = false
				distanceLabel.isHidden = true
				distanceLabel.text = ""
			} else {
				titleRightDistanceAnchorConstraint.isActive = true
				titleRightImageAnchorConstraint.isActive = false
				gpsIconImageView.isHidden = true
				distanceLabel.isHidden = false
				distanceLabel.text = "\(String(format:"%.f", value)) km"
			}
		}
	}

	func setText(text: String, with searchString: String?) {
		if let searchString = searchString {
			// Set initial attributed string
			let attributes = [NSAttributedString.Key.foregroundColor : UIColor.init(named: "TitleColor")!, NSAttributedString.Key.font : Font(.normal, size: .size2).font]
			let mutableAttributedString = NSMutableAttributedString(string: text, attributes: attributes)

			let rangeOptions: String.CompareOptions = [.caseInsensitive, .diacriticInsensitive]

			// Get range of text that requires new attributes
			guard let range = text.range(of: searchString, options: rangeOptions) else
			{
				titleLabel.attributedText = nil
				titleLabel.text = text
				return
			}

			let nsRange = NSRange(range, in: text)

			// Apply new attributes to the text matching the range
			let newAttributes = [NSAttributedString.Key.foregroundColor : UIColor.init(named: "TitleColor")!, NSAttributedString.Key.font : Font(.bold, size: .size2).font] as [NSAttributedString.Key : Any]
			mutableAttributedString.setAttributes(newAttributes, range: nsRange)

			titleLabel.attributedText = mutableAttributedString
		} else {
			titleLabel.attributedText = nil
			titleLabel.text = text
		}
	}
}
