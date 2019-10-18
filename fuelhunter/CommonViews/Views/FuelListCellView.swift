//
//  FuelListCellView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import ActiveLabel

extension UIView {
    func fadeTransition(_ duration:CFTimeInterval) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
            CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

protocol FuelListCellViewDisplayLogic {
    func updateDataWithData(priceData: FuelList.FetchPrices.ViewModel.DisplayedPrice, mapPointData: MapPoint, andCellType cellType: CellBackgroundType)
}

class FuelListCellView: UIView, MapInfoButtonViewButtonLogic {

	public var cellBgType: CellBackgroundType = .unknown

	// Forward this from viewController, so that we can extend white bg on the bottom
	var safeLayoutBottomInset: CGFloat = 0 {
		didSet {
			self.extendedDescriptionLabelBottomConstraint?.constant = -10 - safeLayoutBottomInset
		}
	}
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var backgroundImageView: UIImageView!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var addressesLabel: UILabel!
	@IBOutlet weak var priceLabel: UILabel!
	@IBOutlet weak var separatorView: UIView!
	
	@IBOutlet var extendedBackgroundImageView: UIImageView!
	@IBOutlet var extendedTitleLabel: UILabel!
	@IBOutlet var extendedAddressLabel: UILabel!
	@IBOutlet var mapInfoPriceView: MapInfoButtonView!
	@IBOutlet var mapInfoDistanceView: MapInfoButtonView!
	@IBOutlet var extendedDescriptionLabel: ActiveLabel!
	
	var bgViewBottomAnchorConstraint: NSLayoutConstraint?
	var bgViewTopAnchorConstraint: NSLayoutConstraint?
	
	var iconImageViewLeftConstraint: NSLayoutConstraint?
	var iconImageViewTopConstraint: NSLayoutConstraint?
	var iconImageViewWidthConstraint: NSLayoutConstraint?
	var iconImageViewHeightConstraint: NSLayoutConstraint?
	
	var iconImageViewCenterXConstraint: NSLayoutConstraint?
	
	var priceLabelBottomConstraint: NSLayoutConstraint?
	
	var extendedDescriptionLabelBottomConstraint: NSLayoutConstraint?
		
	
	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("FuelListCellView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false

		baseView.translatesAutoresizingMaskIntoConstraints = false
		backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addressesLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        extendedBackgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        extendedTitleLabel.translatesAutoresizingMaskIntoConstraints = false
       	extendedDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        extendedAddressLabel.translatesAutoresizingMaskIntoConstraints = false
        mapInfoPriceView.translatesAutoresizingMaskIntoConstraints = false
        mapInfoDistanceView.translatesAutoresizingMaskIntoConstraints = false
        
        mapInfoPriceView.controller = self
        mapInfoDistanceView.controller = self
        
        baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
       	baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
       	baseView.backgroundColor = .clear
       	
		backgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		backgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		bgViewBottomAnchorConstraint = backgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
		bgViewBottomAnchorConstraint?.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor)
		bgViewTopAnchorConstraint?.isActive = true

		iconImageViewLeftConstraint = iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10)
		iconImageViewTopConstraint = iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11)
		iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 33)
		iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 33)
		
		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10+10+33).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true

		addressesLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10+10+33).isActive = true
		addressesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		
		
		addressesLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true
		
		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: addressesLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		priceLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
		priceLabelBottomConstraint = priceLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)


				
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		//TODO: Calculate width of normal price, and provide it as minimum
		priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
		


		//--- second type
		extendedBackgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		extendedBackgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		extendedBackgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
		extendedBackgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
		
		iconImageViewCenterXConstraint = iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		extendedTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		extendedTitleLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
		extendedTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 9).isActive = true
		extendedAddressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		extendedAddressLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor).isActive = true
		extendedAddressLabel.topAnchor.constraint(equalTo: extendedTitleLabel.bottomAnchor, constant: 9).isActive = true
		
		
		let infoSpaceLeft = UILayoutGuide()
		self.addLayoutGuide(infoSpaceLeft)
		let infoSpaceRight = UILayoutGuide()
		self.addLayoutGuide(infoSpaceRight)
		let infoSpaceMiddle = UILayoutGuide()
		self.addLayoutGuide(infoSpaceMiddle)
		
		let infoSpaceLeftWidthConstraint = infoSpaceLeft.widthAnchor.constraint(equalToConstant: 1)
		let infoSpaceRightWidthConstraint = infoSpaceRight.widthAnchor.constraint(equalTo: infoSpaceLeft.widthAnchor)
		infoSpaceLeftWidthConstraint.priority = .defaultLow
		infoSpaceRightWidthConstraint.priority = .defaultLow 
		infoSpaceLeftWidthConstraint.isActive = true
		infoSpaceRightWidthConstraint.isActive = true
		infoSpaceMiddle.widthAnchor.constraint(equalToConstant: 20).isActive = true
		infoSpaceLeft.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		infoSpaceRight.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		infoSpaceMiddle.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		mapInfoPriceView.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		mapInfoDistanceView.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		
		infoSpaceLeft.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		mapInfoPriceView.leftAnchor.constraint(equalTo: infoSpaceLeft.rightAnchor).isActive = true
		infoSpaceMiddle.leftAnchor.constraint(equalTo: mapInfoPriceView.rightAnchor).isActive = true
		mapInfoDistanceView.leftAnchor.constraint(equalTo: infoSpaceMiddle.rightAnchor).isActive = true
		infoSpaceRight.leftAnchor.constraint(equalTo: mapInfoDistanceView.rightAnchor).isActive = true
		infoSpaceRight.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
		
		
		extendedDescriptionLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10).isActive = true
		extendedDescriptionLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		extendedDescriptionLabel.topAnchor.constraint(equalTo: mapInfoPriceView.bottomAnchor, constant: 10).isActive = true
		extendedDescriptionLabelBottomConstraint = extendedDescriptionLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)
		//===
		
				
		
		titleLabel.font = Font.init(.medium, size: .size2).font
		addressesLabel.font = Font.init(.normal, size: .size4).font
		priceLabel.font = Font.init(.bold, size: .size1).font
		
		extendedTitleLabel.font = Font.init(.medium, size: .size0).font
		extendedAddressLabel.font = Font.init(.normal, size: .size3).font
		extendedDescriptionLabel.font = Font.init(.normal, size: .size5).font
		
		setUpConstraintsAsBottomView()

        setUpConstraintsAsCell()
	}
	
	func setUpConstraintsAsCell() {
		
		iconImageViewCenterXConstraint?.isActive = false
		
		extendedDescriptionLabelBottomConstraint?.isActive = false
		
		
		iconImageViewLeftConstraint?.isActive = true
		iconImageViewTopConstraint?.isActive = true
		iconImageViewWidthConstraint?.isActive = true
		iconImageViewHeightConstraint?.isActive = true
		priceLabelBottomConstraint?.isActive = true
		
		iconImageViewTopConstraint?.constant = 11
		iconImageViewWidthConstraint?.constant = 33		
		iconImageViewHeightConstraint?.constant = 33
		
		extendedTitleLabel.alpha = 0
		extendedAddressLabel.alpha = 0
		extendedDescriptionLabel.alpha = 0
		mapInfoPriceView.alpha = 0
		mapInfoDistanceView.alpha = 0
		extendedBackgroundImageView.alpha = 0
		
		titleLabel.alpha = 1
		addressesLabel.alpha = 1
		priceLabel.alpha = 1
		separatorView.alpha = 1
		backgroundImageView.alpha = 1

		self.setAsCellType(cellType: cellBgType)
    }
	
	func setUpConstraintsAsBottomView() {
		
		iconImageViewLeftConstraint?.isActive = false
		priceLabelBottomConstraint?.isActive = false

		iconImageViewTopConstraint?.constant = 15
		iconImageViewWidthConstraint?.constant = 60	
		iconImageViewHeightConstraint?.constant = 60
		
		iconImageViewCenterXConstraint?.isActive = true
		
		extendedDescriptionLabelBottomConstraint?.isActive = true
		
		extendedTitleLabel.alpha = 1
		extendedAddressLabel.alpha = 1
		extendedDescriptionLabel.alpha = 1
		mapInfoPriceView.alpha = 1
		mapInfoDistanceView.alpha = 1
		extendedBackgroundImageView.alpha = 1
		
		titleLabel.alpha = 0
		addressesLabel.alpha = 0
		priceLabel.alpha = 0
		separatorView.alpha = 0
		backgroundImageView.alpha = 0
	}
	
	// MARK: Functions

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
			default:
				break
		}
	}

	// MARK: FuelListCellViewDisplayLogic

	func updateDataWithData(priceData: FuelList.FetchPrices.ViewModel.DisplayedPrice, mapPointData: MapPoint, andCellType cellType: CellBackgroundType) {
		titleLabel.fadeTransition(0.2)
		addressesLabel.fadeTransition(0.2)
		iconImageView.fadeTransition(0.2)
		priceLabel.fadeTransition(0.2)

//		if let addressObj = data.address.first {
//			extendedAddressLabel.text = "\(addressObj.name), \(data.city)"
//		} else {
//			extendedAddressLabel.text = ""
//		}

		titleLabel.text = priceData.companyName
		addressesLabel.text = priceData.addressDescription

		extendedAddressLabel.text = mapPointData.address
		extendedTitleLabel.text = mapPointData.companyName
		iconImageView.image = UIImage.init(named: mapPointData.companyBigImageName)
		if mapPointData.priceIsCheapest {
			priceLabel.textColor = UIColor.init(named: "CheapPriceColor")
		} else {
			priceLabel.textColor = UIColor.init(named: "TitleColor")
		}
		
		mapInfoPriceView.setAsType(.typePrice, withText: mapPointData.priceText)
		mapInfoDistanceView.setAsType(.typeDistance, withText: "\(mapPointData.distance) km")
		priceLabel.text = mapPointData.priceText
		
		let customType = ActiveType.custom(pattern: "\\smājaslapas\\b") 
		extendedDescriptionLabel.enabledTypes = [customType]
		extendedDescriptionLabel.text = "Cena pēdējo reizi atjaunota pirms 45 minūtēm. Cena tika iegūta no mājaslapas."
		extendedDescriptionLabel.customColor[customType] = UIColor.init(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
		extendedDescriptionLabel.customSelectedColor[customType] = UIColor.init(red: 29/255, green: 105/255, blue: 255/255, alpha: 1.0)
    	extendedDescriptionLabel.handleCustomTap(for: customType) { element in 
			print("Custom type tapped: \(element)") 
		}
		

		if cellBgType == .unknown {
			self.setAsCellType(cellType: cellType)
		}

		self.cellBgType = cellType

		self.setNeedsLayout()
	}
	
	// MARK: MapInfoButtonViewButtonLogic
	
	func buttonWasPressedForViewType(_ viewType: MapInfoButtonViewType) {
		
	}
}
