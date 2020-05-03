//
//  TextTableViewHeaderView.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit


class TextTableViewHeaderView: FontChangeHeaderFooterView {

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var titleLabel: UILabel!

	var titleLabelTopConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()

		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		self.contentView.backgroundColor = .white

		titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6).isActive = true
		titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6)

		titleLabelTopConstraint.isActive = true

		titleLabel.textColor = UIColor(named: "TitleColor")

		updateFonts()
    }

	func updateFonts() {
		titleLabel.font = Font(.normal, size: .size3).font
	}

    override func fontSizeWasChanged() {
		updateFonts()
	}

	func setSectionIndex(_ sectionIndex: Int) {
		if sectionIndex > 0 {
			titleLabelTopConstraint.constant = 10
		} else {
			titleLabelTopConstraint.constant = 6
		}
	}
}
