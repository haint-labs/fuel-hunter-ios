//
//  SearchTableViewHeaderView.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol SearchTableViewHeaderViewLogic: class {
	func textFieldValueWasChanged(textField: UITextField)
}

class SearchTableViewHeaderView: FontChangeHeaderFooterView {

	public var cellBgType: CellBackgroundType = .single

	weak var controller: SearchTableViewHeaderViewLogic?

	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var separatorView: UIView!
	@IBOutlet weak var textField: UITextField!
	@IBOutlet weak var searchIconImageView: UIImageView!

	var lastActiveTextField: UITextField?

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
		textField.translatesAutoresizingMaskIntoConstraints = false
		searchIconImageView.translatesAutoresizingMaskIntoConstraints = false

		self.contentView.backgroundColor = .white

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
		backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5).isActive = true

		searchIconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10.5).isActive = true
		searchIconImageView.widthAnchor.constraint(equalToConstant: 13).isActive = true
		searchIconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 3).isActive = true
		searchIconImageView.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -5).isActive = true


		textField.leftAnchor.constraint(equalTo: searchIconImageView.rightAnchor, constant: 7).isActive = true
		textField.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 8).isActive = true
		textField.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		textField.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -11).isActive = true
		textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)


		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

    	textField.attributedPlaceholder = NSAttributedString(string: "settings_city_title".localized(), attributes: [NSAttributedString.Key.foregroundColor : UIColor.init(named: "DisabledButtonColor")!])
		backgroundImageView.image = UIImage(named: "cell_bg_top")

		updateFonts()
    }

    @objc func textFieldDidChange() {
    	if textField.text?.isEmpty == true {
			searchIconImageView.isHighlighted = false
		} else {
			searchIconImageView.isHighlighted = true
		}
		controller?.textFieldValueWasChanged(textField: textField)
    }

	func activateTextField() {
		DispatchQueue.main.asyncAfter(deadline: .now()) { self.textField.becomeFirstResponder() }
	}

	func deactivateTextField() {
		textField.endEditing(true)
		self.textField.text = nil
	}

	func updateFonts() {
		textField.font = Font(.normal, size: .size2).font
	}

    override func fontSizeWasChanged() {
		updateFonts()
	}
}
