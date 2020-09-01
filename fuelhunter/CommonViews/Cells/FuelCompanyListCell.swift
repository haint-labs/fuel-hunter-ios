//
//  FuelCompanyListCell.swift
//  fuelhunter
//
//  Created by Guntis on 04/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage

protocol FuelCompanyListCellDisplayLogic {
	func setIconImageFromImageName(imageName: String)
	func setDescriptionText(descriptionText: String)
	func setSwitchAsVisible(_ visible: Bool)
	func setAsCellType(cellType: CellBackgroundType)
}

protocol FuelCompanyListCellSwitchLogic: class {
	func switchWasPressedOnTableViewCell(cell: FuelCompanyListCell, withState state: Bool)
}

class FuelCompanyListCell: FontChangeTableViewCell, FuelCompanyListCellDisplayLogic {

	weak var controller: FuelCompanyListCellSwitchLogic? 
	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!
	var titleLeftImageAnchorConstraint: NSLayoutConstraint!
	var titleLeftCellAnchorConstraint: NSLayoutConstraint!
	var descriptionLeftImageAnchorConstraint: NSLayoutConstraint!
	var descriptionLeftCellAnchorConstraint: NSLayoutConstraint!
	var titleTopAnchorConstraint: NSLayoutConstraint!
	var titleBottomAnchorConstraint: NSLayoutConstraint!
	var descriptionBottomAnchorConstraint: NSLayoutConstraint!

	var iconBottomConstraint: NSLayoutConstraint!

	var titleLabelRightConstraint: NSLayoutConstraint!
	var descriptionLabelRightConstraint: NSLayoutConstraint!
	var switchLeftConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
    override func awakeFromNib() {
        super.awakeFromNib()

        aSwitch.addTarget(self, action: NSSelectorFromString("aSwitchWasPressed:"), for: .valueChanged)

        self.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		let space1 = UILayoutGuide()
		contentView.addLayoutGuide(space1)

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint.isActive = true
		bgViewBottomAnchorConstraint.isActive = true

		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 10).isActive = true
		iconBottomConstraint = iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -11)
		iconBottomConstraint.priority = .defaultHigh
		iconBottomConstraint.isActive = true

		titleLeftImageAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10)
		titleLeftCellAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10)
		titleTopAnchorConstraint = titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6)
		titleTopAnchorConstraint.isActive = true

		titleLabelRightConstraint = titleLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10)

		titleBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -12)

		descriptionLeftImageAnchorConstraint = descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10)
		descriptionLeftCellAnchorConstraint = descriptionLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10)
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true

		descriptionLabelRightConstraint = descriptionLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10)
		descriptionLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true

		space1.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 9).isActive = true
		space1.leftAnchor.constraint(equalTo: descriptionLabel.rightAnchor, constant: 9).isActive = true
		let space1Width = space1.widthAnchor.constraint(equalToConstant: 1)
		space1Width.priority = UILayoutPriority(1)
		space1Width.isActive = true

		aSwitch.widthAnchor.constraint(equalToConstant: aSwitch.intrinsicContentSize.width).isActive = true
		switchLeftConstraint = aSwitch.leftAnchor.constraint(equalTo: space1.rightAnchor)
		aSwitch.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		aSwitch.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		setSwitchAsVisible(true)

    	updateFonts()
    }

    // MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size2).font
		descriptionLabel.font = Font(.normal, size: .size4).font
	}
	
    @objc private func aSwitchWasPressed(_ aSwitch: UISwitch) {
		controller?.switchWasPressedOnTableViewCell(cell: self, withState: aSwitch.isOn)
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// MARK: FuelCompanyListCellDisplayLogic

	func setIconImageFromImageName(imageName: String) {
		if imageName.count == 0 {
			self.iconImageView.image = nil
			self.iconImageView.isHidden = true
			self.titleLeftImageAnchorConstraint.isActive = false
			self.titleLeftCellAnchorConstraint.isActive = true
			self.descriptionLeftImageAnchorConstraint.isActive = false
			self.descriptionLeftCellAnchorConstraint.isActive = true
		} else {
			self.iconImageView.sd_setImage(with: URL.init(string: imageName), placeholderImage: UIImage.init(named: "fuel_icon_placeholder"), options: .retryFailed) { (image, error, cacheType, url) in
//				if error != nil {
//					print("Failed: \(error)")
//				} else {
//					print("Success")
//				}
			}
			self.iconImageView.isHidden = false
			self.titleLeftCellAnchorConstraint.isActive = false
			self.titleLeftImageAnchorConstraint.isActive = true
			self.descriptionLeftCellAnchorConstraint.isActive = false
			self.descriptionLeftImageAnchorConstraint.isActive = true
		}
	}

	func setDescriptionText(descriptionText: String) {
		if descriptionText.count == 0 {
			iconImageView.contentMode = .center
			self.descriptionLabel.text = ""
			self.titleTopAnchorConstraint.constant = 9
			self.titleBottomAnchorConstraint.isActive = true
		} else {
			iconImageView.contentMode = .top
			self.descriptionLabel.text = descriptionText
			self.titleTopAnchorConstraint.constant = 6
			self.titleBottomAnchorConstraint.isActive = false
		}
	}

	func setSwitchAsVisible(_ visible: Bool) {
		self.switchLeftConstraint.isActive = visible
		self.titleLabelRightConstraint.isActive = !visible
		self.descriptionLabelRightConstraint.isActive = !visible
		self.aSwitch.isHidden = !visible
	}

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
}
