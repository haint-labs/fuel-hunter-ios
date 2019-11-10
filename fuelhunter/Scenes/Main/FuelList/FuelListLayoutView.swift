//
//  FuelListLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListLayoutViewLogic: class {
	func savingsButtonPressed()
	func accuracyButtonPressed()
	func pressedOnACell(atYLocation yLocation: CGFloat, forCell cell: FuelListCell, forCompany company: Company, forSelectedFuelType fuelType: FuelType)
}

protocol FuelListLayoutViewDataLogic: class {
	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]])
}

class FuelListLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, FuelListLayoutViewDataLogic {

	weak var controller: FuelListLayoutViewLogic? 

	@IBOutlet var baseView: UIView!
	@IBOutlet weak var inlineAlertView: InlineAlertView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet weak var savingsIconButton: UIButton!
	@IBOutlet weak var savingsLabelButton: UIButton!
	@IBOutlet weak var accuracyIconButton: UIButton!
	@IBOutlet weak var accuracyLabelButton: UIButton!

	var data = [[FuelList.FetchPrices.ViewModel.DisplayedPrice]]()

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
		Bundle.main.loadNibNamed("FuelListLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		inlineAlertView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false
		savingsIconButton.translatesAutoresizingMaskIntoConstraints = false
		savingsLabelButton.translatesAutoresizingMaskIntoConstraints = false
		accuracyIconButton.translatesAutoresizingMaskIntoConstraints = false
		accuracyLabelButton.translatesAutoresizingMaskIntoConstraints = false
		inlineAlertView.translatesAutoresizingMaskIntoConstraints = false
		inlineAlertView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		inlineAlertView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		inlineAlertView.topAnchor.constraint(equalTo: topAnchor).isActive = true

		tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: inlineAlertView.bottomAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: savingsIconButton.topAnchor, constant: -15).isActive = true

		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: topAnchor).isActive = true

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1).isActive = true

		savingsLabelButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

		savingsIconButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		savingsIconButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

		savingsIconButton.bottomAnchor.constraint(equalTo: accuracyIconButton.topAnchor, constant: -15).isActive = true
		savingsLabelButton.bottomAnchor.constraint(equalTo: accuracyIconButton.topAnchor, constant: -15).isActive = true

		savingsIconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
		savingsLabelButton.leftAnchor.constraint(equalTo: savingsIconButton.rightAnchor, constant: 20).isActive = true

		accuracyLabelButton.heightAnchor.constraint(equalToConstant: 25).isActive = true

		accuracyIconButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
		accuracyIconButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

		accuracyIconButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
		accuracyLabelButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true

		accuracyIconButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
		accuracyLabelButton.leftAnchor.constraint(equalTo: accuracyIconButton.rightAnchor, constant: 20).isActive = true

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets.init(top: -6, left: 0, bottom: -9, right: 0)
    	let nib = UINib.init(nibName: "FuelListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")

    	savingsLabelButton.setTitle("Ietaupījums", for: .normal)
    	accuracyLabelButton.setTitle("Degvielas cenu precizitāte", for: .normal)
    	
    	savingsLabelButton.titleLabel!.font = Font.init(.medium, size: .size3).font
		accuracyLabelButton.titleLabel!.font = Font.init(.medium, size: .size3).font
		
		savingsIconButton.addTarget(self, action: NSSelectorFromString("savingsButtonPressed"), for: .touchUpInside)
		accuracyIconButton.addTarget(self, action: NSSelectorFromString("accuracyButtonPressed"), for: .touchUpInside)
		savingsLabelButton.addTarget(self, action: NSSelectorFromString("savingsButtonPressed"), for: .touchUpInside)
		accuracyLabelButton.addTarget(self, action: NSSelectorFromString("accuracyButtonPressed"), for: .touchUpInside)

  	}

  	// MARK: Table view

	func numberOfSections(in tableView: UITableView) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelListCell {
			let aData = self.data[indexPath.section][indexPath.row]
			cell.titleLabel.text = aData.company.name
			cell.addressesLabel.text = aData.addressDescription
			cell.iconImageView.image = UIImage.init(named: aData.company.logoName)
			cell.priceLabel.text = aData.price
			
			if aData.isPriceCheapest == true {
				cell.priceLabel.textColor = UIColor.init(named: "CheapPriceColor") 
			} else {
				cell.priceLabel.textColor = UIColor.init(named: "TitleColor")
			}
			
			cell.selectionStyle = .none
				
			if self.data[indexPath.section].count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if self.data[indexPath.section].first == aData {
					cell.setAsCellType(cellType: .top)
				} else if self.data[indexPath.section].last == aData {
					cell.setAsCellType(cellType: .bottom)
				} else {
					cell.setAsCellType(cellType: .middle)
				}
			}
			return cell
		} else {
			// Problem
			return UITableViewCell.init()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let aData = self.data[section].first!
			
		let baseView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 60))
		
		let label: UILabel = UILabel()
		label.text = aData.fuelType.rawValue
		label.font = Font.init(.medium, size: .size3).font
		label.textColor = UIColor.init(named: "TitleColor")
		
		let height = aData.fuelType.rawValue.height(withConstrainedWidth: self.frame.width-32, font: Font.init(.medium, size: .size3).font)
		
		label.frame = CGRect.init(x: 16, y: 20, width: self.frame.width-32, height: height+6)
		
		baseView.addSubview(label)
		
		return baseView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let aData = self.data[section].first!
		let height = aData.fuelType.rawValue.height(withConstrainedWidth: self.frame.width-32, font: Font.init(.medium, size: .size3).font)
		
		return height + 26
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: check if cell is partly visible. If yes, then first scroll to visible, and then select it?
		let aData = self.data[indexPath.section][indexPath.row]

		let rect = tableView.rectForRow(at: indexPath)
		let rectInScreen = tableView.convert(rect, to: self.superview)
		
		if !tableView.bounds.contains(rect) {
			// Cell is partly visible. So we scroll to reveal it fully. Just a nicety

			tableView.scrollRectToVisible(CGRect.init(x: rect.origin.x, y: rect.origin.y-5, width: rect.width, height: rect.height+10), animated: true)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { 
				let rect = tableView.rectForRow(at: indexPath)
				let rectInScreen = tableView.convert(rect, to: self.superview)
				let cell = tableView.cellForRow(at: indexPath) as! FuelListCell

				self.controller?.pressedOnACell(atYLocation: rectInScreen.origin.y, forCell: cell, forCompany: aData.company, forSelectedFuelType: aData.fuelType)
			}
		} else {
			let cell = tableView.cellForRow(at: indexPath) as! FuelListCell

			controller?.pressedOnACell(atYLocation: rectInScreen.origin.y, forCell: cell, forCompany: aData.company, forSelectedFuelType: aData.fuelType)
		}
	}
	
  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		adjustVisibilityOfShadowLines()
	}

	// MARK: Functions

	func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y-15))/50.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value+5))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

	// MARK: FuelListLayoutViewDataLogic

	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]]) {
		self.data = data
		tableView.reloadData()
		tableView.layoutIfNeeded()
		adjustVisibilityOfShadowLines() 
	}

	// MARK: Functions

	@objc func savingsButtonPressed() {
		controller?.savingsButtonPressed()
	}

	@objc func accuracyButtonPressed() {
		controller?.accuracyButtonPressed()
	}
}
