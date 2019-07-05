//
//  FuelListCell.swift
//  fuelhunter
//
//  Created by Guntis on 09/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class FuelListCell: UITableViewCell {


	public var cellBgType: cellBackgroundType = .single
	
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var addressesLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var topSeparatorView: UIView!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var addressBarBottomAnchorConstraint: NSLayoutConstraint?
	
	var priceBottomAnchorConstraint: NSLayoutConstraint?
	
	
	override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressesLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        topSeparatorView.translatesAutoresizingMaskIntoConstraints = false

		backgroundImageView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5)
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0)
		bgViewTopAnchorConstraint?.isActive = true
		bgViewBottomAnchorConstraint?.isActive = true
			
			
		iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 8.5).isActive = true
		iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10+3).isActive = true
		iconImageView.widthAnchor.constraint(equalToConstant: 33).isActive = true
		iconImageView.heightAnchor.constraint(equalToConstant: 33).isActive = true
		
		
		titleLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 9.5).isActive = true
		titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6+2).isActive = true
		
		addressesLabel.leftAnchor.constraint(equalTo: iconImageView.rightAnchor, constant: 9.5).isActive = true
		addressesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		addressBarBottomAnchorConstraint = addressesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		addressBarBottomAnchorConstraint?.isActive = true
		
		
		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: addressesLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -18).isActive = true
		priceLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6+2).isActive = true
		priceBottomAnchorConstraint = priceLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
		priceBottomAnchorConstraint?.isActive = true
		
		
		topSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		topSeparatorView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
		topSeparatorView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -13).isActive = true
		topSeparatorView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12.5).isActive = true
		
		//TODO: Calculate width of normal price, and provide it as minimum
		priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true


		titleLabel.textColor = UIColor.init(named: "TitleColor")
		titleLabel.font = Font.init(.medium, size: .size2).font
		
		priceLabel.textColor = UIColor.init(named: "TitleColor")
		priceLabel.font = Font.init(.bold, size: .size1).font
		
		addressesLabel.textColor = UIColor.init(named: "SubTitleColor")
		addressesLabel.font = Font.init(.normal, size: .size4).font
		
		topSeparatorView.backgroundColor = UIColor.init(named: "CellSeparatorColor")
		
		iconImageView.image = UIImage.init(named: "virshi_logo")
    }

	func setAsCellType(cellType: cellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint?.constant = 4
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.addressBarBottomAnchorConstraint?.constant = -6.5
				self.priceBottomAnchorConstraint?.constant = -6.5
				self.topSeparatorView.isHidden = true
				break
			case .bottom:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.addressBarBottomAnchorConstraint?.constant = -11
				self.priceBottomAnchorConstraint?.constant = -11
				self.topSeparatorView.isHidden = false
				break
			case .middle:
				self.bgViewTopAnchorConstraint?.constant = -20
				self.bgViewBottomAnchorConstraint?.constant = 20
				self.addressBarBottomAnchorConstraint?.constant = -6
				self.priceBottomAnchorConstraint?.constant = -6
				self.topSeparatorView.isHidden = false
				break
			case .single:
				self.bgViewTopAnchorConstraint?.constant = 5
				self.bgViewBottomAnchorConstraint?.constant = 0
				self.addressBarBottomAnchorConstraint?.constant = -11
				self.priceBottomAnchorConstraint?.constant = -11
				self.topSeparatorView.isHidden = true
		}
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
