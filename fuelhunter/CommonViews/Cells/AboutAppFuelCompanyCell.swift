//
//  AboutAppFuelCompanyCell.swift
//  fuelhunter
//
//  Created by Guntis on 07/07/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class AboutAppFuelCompanyCell: UITableViewCell {

    public var cellBgType: CellBackgroundType = .single

	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!

	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	var bgViewTopAnchorConstraint: NSLayoutConstraint?

    override func awakeFromNib() {
        super.awakeFromNib()

        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true

		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true

		titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true

		descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9).isActive = true

		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		titleLabel.font = Font.init(.medium, size: .size2).font
		descriptionLabel.font = Font.init(.normal, size: .size4).font
    }
	
	func setAsCellType(cellType: CellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage.init(named: "cell_bg_top")
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage.init(named: "cell_bg_bottom")
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage.init(named: "cell_bg_middle")
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage.init(named: "cell_bg_single")
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
