//
//  FuelTypeListCell.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelTypeListCellDisplayLogic {
	func setAsCellType(cellType: CellBackgroundType)
}

protocol FuelTypeListCellSwitchLogic: class {
	func switchWasPressedOnTableViewCell(cell: FuelTypeListCell, withState state: Bool)
}

class FuelTypeListCell: FontChangeTableViewCell, FuelTypeListCellDisplayLogic {

	weak var controller: FuelTypeListCellSwitchLogic? 
    public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
    override func awakeFromNib() {
        super.awakeFromNib()

        aSwitch.addTarget(self, action: NSSelectorFromString("aSwitchWasPressed:"), for: .valueChanged)

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
		aSwitch.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint.isActive = true
		bgViewBottomAnchorConstraint.isActive = true

		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 8).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor, constant: 10).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11).isActive = true

		aSwitch.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		aSwitch.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true
		
		updateFonts()
    }

	// MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size2).font
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
    
	// MARK: FuelTypeListCellDisplayLogic

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
