//
//  LanguageListCell.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class LanguageListCell: UITableViewCell {

    public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var checkBoxImageView: UIImageView!
	
	@IBOutlet weak var separatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var descriptionBottomAnchorConstraint: NSLayoutConstraint?
	
	var checkboxYCenterAnchorConstraint: NSLayoutConstraint?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
		checkBoxImageView.translatesAutoresizingMaskIntoConstraints = false
        
        
		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
		
		
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
		titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: checkBoxImageView.leftAnchor, constant: 10).isActive = true
	
		
		descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: checkBoxImageView.leftAnchor, constant: -9).isActive = true
		descriptionBottomAnchorConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		descriptionBottomAnchorConstraint?.isActive = true
		
		
		checkBoxImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
		checkBoxImageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
		checkBoxImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -25).isActive = true
		checkboxYCenterAnchorConstraint = checkBoxImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
		checkboxYCenterAnchorConstraint?.isActive = true
		
		
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
				self.checkboxYCenterAnchorConstraint?.constant = 1
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.separatorView.isHidden = false
				self.checkboxYCenterAnchorConstraint?.constant = -1
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.descriptionBottomAnchorConstraint?.constant = -6
				self.separatorView.isHidden = false
				self.checkboxYCenterAnchorConstraint?.constant = 1
				break
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.separatorView.isHidden = true
				self.checkboxYCenterAnchorConstraint?.constant = -1
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
