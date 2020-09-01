//
//  FuelListCellView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import ActiveLabel
import SDWebImage

protocol FuelListCellViewDisplayLogic {
	func setUpConstraintsAsCell()
	func setUpConstraintsAsBottomView()
	func setAsCellType(cellType: CellBackgroundType)
    func updateDataWithData(priceData: Map.MapData.ViewModel.DisplayedMapPoint, mapPointData: MapPoint, andCellType cellType: CellBackgroundType)
    func refreshDataWithData(mapPointData: MapPoint)
}

protocol FuelListCellViewButtonLogic: class {
    func userPressedOnNavigationButton()
}

class FuelListCellView: UIView, MapInfoButtonViewButtonLogic, FuelListCellViewDisplayLogic {

	public var cellBgType: CellBackgroundType = .unknown

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
	@IBOutlet var extendedNoInfoLabel: UILabel!
	@IBOutlet var mapInfoPriceView: MapInfoButtonView!
	@IBOutlet var mapInfoDistanceView: MapInfoButtonView!

	weak var controller: FuelListCellViewButtonLogic?


	var bgViewBottomAnchorConstraint: NSLayoutConstraint!
	var bgViewTopAnchorConstraint: NSLayoutConstraint!
	
	var iconImageViewLeftConstraint: NSLayoutConstraint!
	var iconImageViewTopConstraint: NSLayoutConstraint!
	var iconImageViewWidthConstraint: NSLayoutConstraint!
	var iconImageViewHeightConstraint: NSLayoutConstraint!
	var iconBottomConstraint: NSLayoutConstraint!

	var iconImageViewCenterXConstraint: NSLayoutConstraint!
	
	var priceLabelBottomConstraint: NSLayoutConstraint!
	
	var extendedDescriptionLabelBottomConstraint: NSLayoutConstraint!
	var extendedNoInfoLabelBottomConstraint: NSLayoutConstraint!
	
	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("FuelListCellView", owner: self, options: nil)
		addSubview(baseView)

		iconImageView.contentMode = .scaleAspectFit
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
       	extendedAddressLabel.translatesAutoresizingMaskIntoConstraints = false
       	extendedNoInfoLabel.translatesAutoresizingMaskIntoConstraints = false
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
		bgViewBottomAnchorConstraint.isActive = true
		bgViewTopAnchorConstraint = backgroundImageView.topAnchor.constraint(equalTo: self.topAnchor)
		bgViewTopAnchorConstraint.isActive = true

		iconImageViewLeftConstraint = iconImageView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 10)
		iconImageViewTopConstraint = iconImageView.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 11)
		iconImageViewWidthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 33)
		iconImageViewHeightConstraint = iconImageView.heightAnchor.constraint(equalToConstant: 33)
		iconBottomConstraint = iconImageView.bottomAnchor.constraint(lessThanOrEqualTo: backgroundImageView.bottomAnchor, constant: -11)
		iconBottomConstraint.priority = .defaultHigh
		iconBottomConstraint.isActive = true
		
		titleLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 20+33).isActive = true
		titleLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor, constant: 6).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -6).isActive = true

		addressesLabel.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor, constant: 20+33).isActive = true
		addressesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 1).isActive = true
		addressesLabel.rightAnchor.constraint(equalTo: priceLabel.leftAnchor, constant: -6).isActive = true
		
		addressesLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -9).isActive = true
		
//		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: titleLabel.rightAnchor, constant: 6).isActive = true
//		priceLabel.leftAnchor.constraint(greaterThanOrEqualTo: addressesLabel.rightAnchor, constant: 6).isActive = true
		priceLabel.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor, constant: -10).isActive = true
		priceLabel.topAnchor.constraint(equalTo: backgroundImageView.topAnchor).isActive = true
		priceLabelBottomConstraint = priceLabel.bottomAnchor.constraint(equalTo: backgroundImageView.bottomAnchor)


				
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: -1).isActive = true
		separatorView.rightAnchor.constraint(equalTo: backgroundImageView.rightAnchor).isActive = true
		separatorView.leftAnchor.constraint(equalTo: backgroundImageView.leftAnchor).isActive = true

		//TODO: Calculate width of normal price, and provide it as minimum
//		priceLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
		priceLabel.widthAnchor.constraint(equalToConstant:priceLabel.intrinsicContentSize.width).isActive = true


		//--- second type
		extendedBackgroundImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		extendedBackgroundImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		extendedBackgroundImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5).isActive = true
		extendedBackgroundImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
		
		iconImageViewCenterXConstraint = iconImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor)
		extendedTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		extendedTitleLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, constant: -4).isActive = true
		extendedTitleLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 9).isActive = true
		extendedAddressLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		extendedAddressLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, constant: -4).isActive = true
		extendedAddressLabel.topAnchor.constraint(equalTo: extendedTitleLabel.bottomAnchor, constant: 9).isActive = true

		extendedNoInfoLabel.topAnchor.constraint(equalTo: extendedAddressLabel.bottomAnchor, constant: 10).isActive = true
		extendedNoInfoLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		extendedNoInfoLabel.widthAnchor.constraint(equalTo: backgroundImageView.widthAnchor, constant: -4).isActive = true

		
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


		extendedDescriptionLabelBottomConstraint = mapInfoDistanceView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)

		extendedNoInfoLabelBottomConstraint = extendedNoInfoLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15)
		//===
		
		titleLabel.font = Font(.medium, size: .size2).font
		addressesLabel.font = Font(.normal, size: .size4).font
		priceLabel.font = Font(.bold, size: .size1).font
		
		extendedTitleLabel.font = Font(.medium, size: .size0).font
		extendedAddressLabel.font = Font(.normal, size: .size3).font
		
		setUpConstraintsAsBottomView()

        setUpConstraintsAsCell()
	}

	// MARK: FuelListCellViewDisplayLogic

	func setUpConstraintsAsCell() {
		iconImageViewCenterXConstraint.isActive = false
		extendedDescriptionLabelBottomConstraint.isActive = false

		iconImageViewLeftConstraint.isActive = true
		iconImageViewTopConstraint.isActive = true
		iconImageViewWidthConstraint.isActive = true
		iconImageViewHeightConstraint.isActive = true
		iconBottomConstraint.isActive = true
		priceLabelBottomConstraint.isActive = true


		iconImageViewTopConstraint.constant = 11
		iconImageViewWidthConstraint.constant = 33

		self.iconBottomConstraint.constant = -11

		if let image = iconImageView.image {
			let aspect = image.size.height / image.size.width
			iconImageViewHeightConstraint.constant = min(33, iconImageViewWidthConstraint.constant * aspect)


//			self.iconBottomConstraint.constant = -11 - (self.iconImageViewHeightConstraint.constant - self.iconImageViewHeightConstraint.constant)
		} else {
			iconImageViewHeightConstraint.constant = 33
//			self.iconBottomConstraint.constant = -11
		}



		extendedTitleLabel.alpha = 0
		extendedAddressLabel.alpha = 0
		mapInfoPriceView.alpha = 0
		mapInfoDistanceView.alpha = 0
		extendedBackgroundImageView.alpha = 0
		
		titleLabel.alpha = 1
		addressesLabel.alpha = 1
		priceLabel.alpha = 1
		separatorView.alpha = 1
		backgroundImageView.alpha = 1


		setAsCellType(cellType: cellBgType)
    }
	
	func setUpConstraintsAsBottomView() {
		iconImageViewLeftConstraint.isActive = false
		priceLabelBottomConstraint.isActive = false

		iconImageViewTopConstraint.constant = 15
		iconImageViewWidthConstraint.constant = 60
		iconImageViewHeightConstraint.constant = 60

		iconBottomConstraint.isActive = false

		iconImageViewCenterXConstraint.isActive = true
		extendedDescriptionLabelBottomConstraint.isActive = true
		
		extendedTitleLabel.alpha = 1
		extendedAddressLabel.alpha = 1
		mapInfoPriceView.alpha = 1
		mapInfoDistanceView.alpha = 1
		extendedBackgroundImageView.alpha = 1
		
		titleLabel.alpha = 0
		addressesLabel.alpha = 0
		priceLabel.alpha = 0
		separatorView.alpha = 0
		backgroundImageView.alpha = 0
	}

	func setAsCellType(cellType: CellBackgroundType) {
		switch cellType {
			case .top:
				self.bgViewTopAnchorConstraint.constant = 5
				self.bgViewBottomAnchorConstraint.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_top")
			case .bottom:
				self.bgViewTopAnchorConstraint.constant = 0
				self.bgViewBottomAnchorConstraint.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_bottom")
			case .middle:
				self.bgViewTopAnchorConstraint.constant = 0
				self.bgViewBottomAnchorConstraint.constant = 0
				self.separatorView.isHidden = false
				backgroundImageView.image = UIImage(named: "cell_bg_middle")
			case .single:
				self.bgViewTopAnchorConstraint.constant = 5
				self.bgViewBottomAnchorConstraint.constant = -5
				self.separatorView.isHidden = true
				backgroundImageView.image = UIImage(named: "cell_bg_single")
			default:
				break
		}
	}

	func updateDataWithData(priceData: Map.MapData.ViewModel.DisplayedMapPoint, mapPointData: MapPoint, andCellType cellType: CellBackgroundType) {
		titleLabel.fadeTransition(0.2)
		addressesLabel.fadeTransition(0.2)
		iconImageView.fadeTransition(0.2)
		priceLabel.fadeTransition(0.2)

		extendedNoInfoLabel.text = "Diemžēl pēdējo 24 h laikā, neviens nav ievadījis cenu šajā stacijā."

		titleLabel.text = priceData.company.name
		addressesLabel.text = priceData.addressDescription



		extendedAddressLabel.text = mapPointData.address
		extendedTitleLabel.text = mapPointData.company.name

		iconImageView.sd_setImage(with: URL.init(string: mapPointData.company.largeLogoName ?? ""), placeholderImage: UIImage.init(named: "fuel_icon_big_placeholder"), options: .retryFailed) { (image, error, cacheType, url) in
//				if error != nil {
//					print("Failed: \(error)")
//				} else {
//					print("Success")
//				}
			}

		if mapPointData.priceIsCheapest {
			priceLabel.textColor = UIColor(named: "CheapPriceColor")
		} else {
			priceLabel.textColor = UIColor(named: "TitleColor")
		}

		refreshDataWithData(mapPointData: mapPointData)

		mapInfoPriceView.setAsType(.typePrice, withText: mapPointData.priceText)

		priceLabel.text = mapPointData.priceText

		if mapPointData.priceText == "0" {
			self.setPriceAsHidden(true)
		} else {
			self.setPriceAsHidden(false)
		}

		if cellBgType == .unknown {
			setAsCellType(cellType: cellType)
		}

		self.cellBgType = cellType

		self.setNeedsLayout()
	}

	func refreshDataWithData(mapPointData: MapPoint) {

		var distance = mapPointData.distanceInMeters/1000
		distance = distance.rounded(rule: .down, scale: 1)

//		if(distance > 3) {
//			mapInfoDistanceView.setAsType(.typeDistance, withText: "-1")
//		}
		if mapPointData.distanceInMeters < 0 {
			mapInfoDistanceView.setAsType(.typeDistance, withText: "-1")
		} else if(distance >= 0.2) {
			mapInfoDistanceView.setAsType(.typeDistance, withText: "\(distance) \("map_kilometers".localized())")
		} else {
			mapInfoDistanceView.setAsType(.typeDistance, withText: "\(Int(mapPointData.distanceInMeters)) \("map_meters".localized())")
		}
	}

	func setPriceAsHidden(_ hidden: Bool) {
		mapInfoPriceView.isHidden = hidden
		mapInfoDistanceView.isHidden = hidden

		extendedNoInfoLabel.isHidden = !hidden
		extendedNoInfoLabelBottomConstraint.isActive = hidden
		extendedDescriptionLabelBottomConstraint.isActive = !hidden
	}

	// MARK: MapInfoButtonViewButtonLogic
	
	func buttonWasPressedForViewType(_ viewType: MapInfoButtonViewType) {
		print(viewType)
		if viewType == .typeDistance {
			self.controller?.userPressedOnNavigationButton()
		}
	}
}
