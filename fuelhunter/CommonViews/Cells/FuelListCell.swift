//
//  FuelListCell.swift
//  fuelhunter
//
//  Created by Guntis on 09/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage

protocol FuelListCellDisplayLogic {
    func setAsCellType(cellType: CellBackgroundType)
    func setImageWithName(_ name: String?)
}

class FuelListCell: FontChangeTableViewCell, FuelListCellDisplayLogic {

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var addressesLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!
	var iconBottomConstraint: NSLayoutConstraint!

	var iconImageViewHeightConstraint: NSLayoutConstraint!
	var iconImageViewWidthConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
	override func awakeFromNib() {
        super.awakeFromNib()

		iconImageView.contentMode = .scaleAspectFit

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressesLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bgViewBottomAnchorConstraint.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		bgViewTopAnchorConstraint.isActive = true

		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11).isActive = true
		iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 33)
		iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 33)

		iconImageViewWidthConstraint.isActive = true;
		iconImageViewHeightConstraint.isActive = true;


		iconBottomConstraint = iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -11)
		iconBottomConstraint.priority = .defaultHigh
		iconBottomConstraint.isActive = true
		
		titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -6).isActive = true

		addressesLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		addressesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		addressesLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true
		addressesLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -6).isActive = true

		priceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		priceLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
		priceLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

		updateFonts()
    }

	// MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size2).font
		priceLabel.font = Font(.bold, size: .size1).font
		addressesLabel.font = Font(.normal, size: .size4).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
	}

	override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// MARK: FuelListCellDisplayLogic

	func setAsCellType(cellType: CellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_top")
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_bottom")
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_middle")
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_single")
			default:
				break
		}
	}

	func setImageWithName(_ name: String?) {

		self.iconImageViewHeightConstraint.constant = 33
		self.iconBottomConstraint.constant = -11

		iconImageView.sd_setImage(with: URL.init(string: name ?? ""), placeholderImage: UIImage.init(named: "fuel_icon_placeholder"), options: .retryFailed) { (image, error, cacheType, url) in

			if let usedImage = image {
				let aspect = usedImage.size.height / usedImage.size.width
				self.iconImageViewHeightConstraint.constant = min(33, self.iconImageViewWidthConstraint.constant * aspect)
//				self.iconBottomConstraint.constant = -11 - (self.iconImageViewHeightConstraint.constant - self.iconImageViewHeightConstraint.constant)
			} else {
				self.iconImageViewHeightConstraint.constant = 33
//				self.iconBottomConstraint.constant = -11
			}

//			if error != nil {
//				print("Failed: \(error)")
//			} else {
//				print("Success")
//			}
		}
	}
}
