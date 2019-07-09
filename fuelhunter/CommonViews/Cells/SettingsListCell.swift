//
//  SettingsListCell.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class SettingsListCell: UITableViewCell {

	public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	@IBOutlet weak var accessoryIconImageView: UIImageView!
	@IBOutlet weak var separatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	var titleRightAnchorConstraint: NSLayoutConstraint?
	var descriptionRightAnchorConstraint: NSLayoutConstraint?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        accessoryIconImageView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
		bgViewBottomAnchorConstraint?.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor)
		bgViewTopAnchorConstraint?.isActive = true
		
		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true
		titleRightAnchorConstraint = titleLabel.rightAnchor.constraint(equalTo: accessoryIconImageView.leftAnchor, constant: -10)
		titleRightAnchorConstraint?.isActive = true

		descriptionLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		descriptionRightAnchorConstraint = descriptionLabel.rightAnchor.constraint(equalTo: accessoryIconImageView.leftAnchor, constant: -10)
		descriptionRightAnchorConstraint?.isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -10).isActive = true
		
		
		aSwitch.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		aSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		
		
		accessoryIconImageView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		accessoryIconImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
		accessoryIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
		
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
	
	func setSwitch(asVisible switchIsVisible: Bool) {
		if switchIsVisible {
			self.aSwitch.isHidden = false
			self.accessoryIconImageView.isHidden = true
			titleRightAnchorConstraint?.constant = -45
			descriptionRightAnchorConstraint?.constant = -45
		} else {
			self.aSwitch.isHidden = true
			self.accessoryIconImageView.isHidden = false
			titleRightAnchorConstraint?.constant = -10
			descriptionRightAnchorConstraint?.constant = -10
		}
	}
	
	func setAsCellType(cellType: cellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage.init(named: "cell_bg_top")
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage.init(named: "cell_bg_bottom")
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = 0
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage.init(named: "cell_bg_middle")
				break
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
