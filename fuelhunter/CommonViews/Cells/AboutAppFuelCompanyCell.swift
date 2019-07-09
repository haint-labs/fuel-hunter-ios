//
//  AboutAppFuelCompanyCell.swift
//  fuelhunter
//
//  Created by Guntis on 07/07/2019.
//  Copyright © 2019. All rights reserved.
//

import UIKit

class AboutAppFuelCompanyCell: UITableViewCell {

    public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!

	@IBOutlet weak var separatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var descriptionBottomAnchorConstraint: NSLayoutConstraint?
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
		
		
		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
		iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 13).isActive = true
		
		
		titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
		
		descriptionLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -18).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionBottomAnchorConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		descriptionBottomAnchorConstraint?.isActive = true
		
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		
		
		titleLabel.textColor = UIColor.init(named: "TitleColor")
		titleLabel.font = Font.init(.medium, size: .size2).font
		
		descriptionLabel.textColor = UIColor.init(named: "SubTitleColor")
		descriptionLabel.font = Font.init(.normal, size: .size4).font
		
		separatorView.backgroundColor = UIColor.init(named: "CellSeparatorColor")
    }
	
	func setAsCellType(cellType: cellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 4
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.descriptionBottomAnchorConstraint?.constant = -6.5
				self.separatorView.isHidden = true
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.separatorView.isHidden = false
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.descriptionBottomAnchorConstraint?.constant = -6
				self.separatorView.isHidden = false
				break
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.separatorView.isHidden = true
			}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }    
}
