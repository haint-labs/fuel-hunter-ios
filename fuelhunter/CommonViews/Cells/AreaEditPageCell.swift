//
//  AreaEditPageCell.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol AreaEditPageCellDisplayLogic {
    func setAsCellType(cellType: CellBackgroundType)
    func setAccessoryIconType(type: CellAccessoryType, toggleOrCheckmarkIsOn: Bool)
    func activateTextField()
}

protocol AreaEditPageCellDataLogic: class {
	func textFieldShouldResign(cell: AreaEditPageCell)
	func switchWasPressedOnTableViewCell(cell: AreaEditPageCell, withState state: Bool)
}

class AreaEditPageCell: FontChangeTableViewCell, AreaEditPageCellDisplayLogic, UITextFieldDelegate {

	weak var controller: AreaEditPageCellDataLogic?

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet var titleTextField: UITextField!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var accessoryIconImageView: UIImageView!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var aSwitch: UISwitch!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!
	var titleLeftSideAnchorConstraint: NSLayoutConstraint!
	var titleLeftImageAnchorConstraint: NSLayoutConstraint!
	var titleRightAnchorConstraint: NSLayoutConstraint!
	var accessoryWidthAnchorConstraint: NSLayoutConstraint!
	var accessoryRightAnchorConstraint: NSLayoutConstraint!

	// MARK: View lifecycle
	
    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        accessoryIconImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
		aSwitch.translatesAutoresizingMaskIntoConstraints = false

		iconImageView.contentMode = .scaleAspectFit
		iconImageView.backgroundColor = .clear

		titleTextField.delegate = self
		titleTextField.textContentType = .name
		titleTextField.autocapitalizationType = .sentences

		aSwitch.addTarget(self, action: NSSelectorFromString("aSwitchWasPressed:"), for: .valueChanged)

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bgViewBottomAnchorConstraint.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		bgViewTopAnchorConstraint.isActive = true

		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true

		titleLeftSideAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10)
		titleLeftImageAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10)

		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true
		titleRightAnchorConstraint = titleLabel.rightAnchor.constraint(equalTo: accessoryIconImageView.leftAnchor, constant: -10)
		titleRightAnchorConstraint.isActive = true

		titleTextField.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0).isActive = true
		titleTextField.rightAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 0).isActive = true
		titleTextField.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: 1).isActive = true
		titleTextField.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true

		descriptionLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true

		accessoryRightAnchorConstraint = accessoryIconImageView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor)
		accessoryRightAnchorConstraint.isActive = true
		accessoryWidthAnchorConstraint = accessoryIconImageView.widthAnchor.constraint(equalToConstant: 10)

//		titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

		accessoryWidthAnchorConstraint.isActive = true
		accessoryIconImageView.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true

		aSwitch.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		aSwitch.centerYAnchor.constraint(equalTo: backgroundImageView.centerYAnchor).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		
    	updateFonts()
//		self.accessoryIconImageView.isHidden = false
    }

	// MARK: Functions

	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size2).font
		descriptionLabel.font = Font(.normal, size: .size4).font
		titleTextField.font = Font(.medium, size: .size2).font
	}

	@objc private func aSwitchWasPressed(_ aSwitch: UISwitch) {
		controller?.switchWasPressedOnTableViewCell(cell: self, withState: aSwitch.isOn)
	}

	func activateTextField() {
		titleTextField.becomeFirstResponder()
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	// MARK: UITextFieldDelegate

    internal func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    	return true
	}

	internal func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

		DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
			if let text = textField.text {
				if (text.count > 22) {
					textField.text = String(Array(text)[0..<22])
				}
			}
		}
		
		return true
	}

	internal func textFieldShouldReturn(_ textField: UITextField) -> Bool { // called when 'return' key pressed. return NO to ignore.
		if var text = textField.text {
			text = text.trimmingCharacters(in: .whitespacesAndNewlines)

			if text.count == 0 {
				textField.text = "Jauna vieta"
			} else {
				textField.text = text
			}
		} else {
			textField.text = "Jauna vieta"
		}

		controller?.textFieldShouldResign(cell: self)

		return true
	}

	// MARK: AreaListCellDisplayLogic

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

	func setAccessoryIconType(type: CellAccessoryType, toggleOrCheckmarkIsOn: Bool) {
		switch type {
			case .cellAccessoryTypeNone:
				accessoryWidthAnchorConstraint.constant = 13
				titleRightAnchorConstraint.constant = -10
				accessoryRightAnchorConstraint.constant = -12
				accessoryIconImageView.image = nil
				aSwitch.isHidden = true
				iconImageView.isHidden = true
				titleTextField.isHidden = true
				titleLabel.isHidden = false
				titleLeftImageAnchorConstraint.isActive = false
				titleLeftSideAnchorConstraint.isActive = true
				titleLabel.textColor = UIColor(named: "TitleColor")!

			case .cellAccessoryTypeName:
				accessoryWidthAnchorConstraint.constant = 13
				titleRightAnchorConstraint.constant = -10
				accessoryRightAnchorConstraint.constant = -12
				accessoryIconImageView.image = UIImage(named: "edit_icon")
				aSwitch.isHidden = true
				iconImageView.isHidden = true
				titleTextField.isHidden = false
				titleLabel.isHidden = true
				titleLeftImageAnchorConstraint.isActive = false
				titleLeftSideAnchorConstraint.isActive = true
				titleLabel.textColor = UIColor(named: "TitleColor")!

			case .cellAccessoryTypeDelete:
				accessoryWidthAnchorConstraint.constant = 10
				titleRightAnchorConstraint.constant = -10
				accessoryRightAnchorConstraint.constant = -12
				accessoryIconImageView.image = UIImage(named: "delete_icon")
				aSwitch.isHidden = true
				iconImageView.isHidden = true
				titleTextField.isHidden = true
				titleLabel.isHidden = false
				titleLeftImageAnchorConstraint.isActive = false
				titleLeftSideAnchorConstraint.isActive = true
				titleLabel.textColor = UIColor(named: "CancelButtonColor")!

			case .cellAccessoryTypeToggle:
				accessoryWidthAnchorConstraint.constant = 15
				titleRightAnchorConstraint.constant = -aSwitch.intrinsicContentSize.width + 2
				accessoryRightAnchorConstraint.constant = -10
				accessoryIconImageView.image = nil
				aSwitch.isHidden = false
				iconImageView.isHidden = true
				titleTextField.isHidden = true
				titleLabel.isHidden = false
				titleLeftImageAnchorConstraint.isActive = false
				titleLeftSideAnchorConstraint.isActive = true
				titleLabel.textColor = UIColor(named: "TitleColor")!
				aSwitch.isOn = toggleOrCheckmarkIsOn

			case .cellAccessoryTypeCheckMark:
				accessoryWidthAnchorConstraint.constant = 20
				titleRightAnchorConstraint.constant = -10
				accessoryRightAnchorConstraint.constant = -10
				accessoryIconImageView.image = UIImage(named: "check_icon")
				aSwitch.isHidden = true
				iconImageView.isHidden = false
				titleTextField.isHidden = true
				titleLabel.isHidden = false
				titleLeftSideAnchorConstraint.isActive = false
				titleLeftImageAnchorConstraint.isActive = true
				titleLabel.textColor = UIColor(named: "TitleColor")!
				if toggleOrCheckmarkIsOn == true {
					accessoryIconImageView.alpha = 1
				} else {
					accessoryIconImageView.alpha = 0
				}
		}
	}
}
