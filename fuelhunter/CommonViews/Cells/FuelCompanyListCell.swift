//
//  FuelCompanyListCell.swift
//  fuelhunter
//
//  Created by Guntis on 04/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class FuelCompanyListCell: UITableViewCell {


	public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var aSwitch: UISwitch!
	
	@IBOutlet weak var separatorView: UIView!
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var titleLeftImageAnchorConstraint: NSLayoutConstraint?
	
	var titleLeftCellAnchorConstraint: NSLayoutConstraint?
	
	var titleTopAnchorConstraint: NSLayoutConstraint?
	
	var titleBottomAnchorConstraint: NSLayoutConstraint?
	
	var descriptionBottomAnchorConstraint: NSLayoutConstraint?
	
	var switchYAnchorConstraint: NSLayoutConstraint?
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        aSwitch.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
		backgroundImageView.backgroundColor = .red
		
		iconImageView.widthAnchor.constraint(equalToConstant: 22).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 22).isActive = true
		iconImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 26).isActive = true
		iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 11).isActive = true
		
		
		titleLeftImageAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 10)
		titleLeftCellAnchorConstraint = titleLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25)
		titleLeftImageAnchorConstraint?.isActive = true
		titleTopAnchorConstraint = titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9)
		titleTopAnchorConstraint?.isActive = true
		titleLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor, constant: 10).isActive = true
		titleBottomAnchorConstraint = titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		
		descriptionLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 25).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: aSwitch.leftAnchor, constant: -9).isActive = true
		descriptionBottomAnchorConstraint = descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		
		
		aSwitch.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -24).isActive = true
		switchYAnchorConstraint = aSwitch.centerYAnchor.constraint(equalTo: contentView.superview!.centerYAnchor, constant: 1)
		switchYAnchorConstraint?.isActive = true
		
		
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

	func setIconImageFromImageName(imageName: String!) {
		if imageName.count == 0 {
			self.iconImageView.image = nil
			self.iconImageView.isHidden = true
			self.titleLeftImageAnchorConstraint?.isActive = false
			self.titleLeftCellAnchorConstraint?.isActive = true
		} else {
			self.iconImageView.image = UIImage.init(named: imageName)
			self.iconImageView.isHidden = false
			self.titleLeftImageAnchorConstraint?.isActive = true
			self.titleLeftCellAnchorConstraint?.isActive = false
		}
	}
	
	func setDescriptionText(descriptionText: String!) {
		if descriptionText.count == 0 {
			self.titleTopAnchorConstraint?.constant = 10
			self.descriptionLabel.text = ""
			self.titleBottomAnchorConstraint?.isActive = true
			self.descriptionBottomAnchorConstraint?.isActive = false
		} else {
			self.titleTopAnchorConstraint?.constant = 7
			self.descriptionLabel.text = descriptionText
			self.titleBottomAnchorConstraint?.isActive = false
			self.descriptionBottomAnchorConstraint?.isActive = true
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
