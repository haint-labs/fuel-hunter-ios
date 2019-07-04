//
//  SettingsListCell.swift
//  fuelhunter
//
//  Created by Guntis on 03/07/2019.
//  Copyright © 2019 myEmerg. All rights reserved.
//

import UIKit

class SettingsListCell: UITableViewCell {

	public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	@IBOutlet weak var accessoryIconImageView: UIImageView!
	@IBOutlet weak var topSeparatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var descriptionBottomAnchorConstraint: NSLayoutConstraint?
	
	var switchBottomAnchorConstraint: NSLayoutConstraint?
	
	var accessoryIconBottomAnchorConstraint: NSLayoutConstraint?
	
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        accessoryIconImageView.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
	
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
		
		
		titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6+2).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor).isActive = true

		
		descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 24).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor).isActive = true
		descriptionBottomAnchorConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		descriptionBottomAnchorConstraint?.isActive = true
		
		
		aSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
		aSwitch.centerYAnchor.constraint(equalTo: contentView.superview!.centerYAnchor).isActive = true
		
		
		accessoryIconImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
		accessoryIconImageView.widthAnchor.constraint(equalToConstant: 10).isActive = true
		accessoryIconImageView.centerYAnchor.constraint(equalTo: contentView.superview!.centerYAnchor).isActive = true
		
		
		
		topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
		topSeparatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13).isActive = true
		topSeparatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12.5).isActive = true
		
		
		titleLabel.textColor = UIColor.init(named: "TitleColor")
		titleLabel.font = Font.init(.medium, size: .size2).font
		
		descriptionLabel.textColor = UIColor.init(named: "SubTitleColor")
		descriptionLabel.font = Font.init(.normal, size: .size4).font
		
		topSeparatorView.backgroundColor = UIColor.init(named: "CellSeparatorColor")
    }

	func setAsCellType(cellType: cellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 4
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.descriptionBottomAnchorConstraint?.constant = -6.5
				self.topSeparatorView.isHidden = true
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.topSeparatorView.isHidden = false
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.descriptionBottomAnchorConstraint?.constant = -6
				self.topSeparatorView.isHidden = false
				break
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.descriptionBottomAnchorConstraint?.constant = -11
				self.topSeparatorView.isHidden = true
		}
	}
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
