//
//  FuelListHeaderView.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListHeaderViewDisplayLogic {
    func setSectionIndex(_ sectionIndex: Int)
}

class FuelListHeaderView: FontChangeHeaderFooterView, FuelListHeaderViewDisplayLogic {

	public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var titleLabel: UILabel!

	var titleLabelTopConstraint: NSLayoutConstraint!
	var titleLabelBottomConstraint: NSLayoutConstraint!

	// MARK: View lifecycle

    override func awakeFromNib() {
        super.awakeFromNib()

		titleLabel.translatesAutoresizingMaskIntoConstraints = false

		self.contentView.backgroundColor = .white

		titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		titleLabelBottomConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
		titleLabelBottomConstraint.priority = .defaultLow
		titleLabelBottomConstraint.isActive = true
		titleLabelTopConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20) //24
		titleLabelTopConstraint.isActive = true

		titleLabel.textColor = UIColor(named: "TitleColor")

		updateFonts()
    }

	// MARK: Functions
	
	private func updateFonts() {
		titleLabel.font = Font(.medium, size: .size3).font
	}

    override func fontSizeWasChanged() {
		updateFonts()
	}

	// MARK: FuelListHeaderViewDisplayLogic
	
	func setSectionIndex(_ sectionIndex: Int) {
		if sectionIndex > 0 {
			titleLabelTopConstraint.constant = 20
		} else {
			titleLabelTopConstraint.constant = 6
		}
	}
}
