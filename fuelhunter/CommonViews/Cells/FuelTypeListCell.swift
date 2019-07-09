//
//  FuelTypeListCell.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class FuelTypeListCell: UITableViewCell {

    public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	
	@IBOutlet weak var separatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var titleBottomAnchorConstraint: NSLayoutConstraint?
	
	var switchYAnchorConstraint: NSLayoutConstraint?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
		aSwitch.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
		
		
		titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor, constant: 10).isActive = true
		titleBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		titleBottomAnchorConstraint?.isActive = true
		
		aSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
		switchYAnchorConstraint = aSwitch.centerYAnchor.constraint(equalTo: contentView.superview!.centerYAnchor, constant: 1)
		switchYAnchorConstraint?.isActive = true
		
		
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		
		
		titleLabel.textColor = UIColor.init(named: "TitleColor")
		titleLabel.font = Font.init(.medium, size: .size2).font
		
		separatorView.backgroundColor = UIColor.init(named: "CellSeparatorColor")
    }
	
	func setAsCellType(cellType: cellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 4
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.titleBottomAnchorConstraint?.constant = -8
				self.separatorView.isHidden = true
				self.switchYAnchorConstraint?.constant = 1
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.titleBottomAnchorConstraint?.constant = -15
				self.separatorView.isHidden = false
				self.switchYAnchorConstraint?.constant = -1
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.titleBottomAnchorConstraint?.constant = -10
				self.separatorView.isHidden = false
				self.switchYAnchorConstraint?.constant = 1
				break
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.titleBottomAnchorConstraint?.constant = -13
				self.separatorView.isHidden = true
				self.switchYAnchorConstraint?.constant = -1
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
