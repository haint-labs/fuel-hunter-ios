//
//  FuelListLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage

protocol FuelListLayoutViewLogic: class {
	func savingsButtonPressed()
	func accuracyButtonPressed()
	func pressedOnACell(atYLocation yLocation: CGFloat, forCell cell: FuelListCell, forCompany company: CompanyEntity, forSelectedFuelType fuelType: FuelType)
	func closestCityNameButtonWasPressed()
}

protocol FuelListLayoutViewDataLogic: class {
	func adjustVisibilityOfShadowLines()
	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]], insertItems: [IndexPath], deleteItems: [IndexPath], updateItems: [IndexPath], insertSections: [Int], deleteSections: [Int], updateSections: [Int])
	func updateCity(_ name: String, gpsIconVisible: Bool)
	func resetUI()
}

class FuelListLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, FuelListLayoutViewDataLogic, InlineAlertViewLogic, ClosestCityNameButtonViewButtonLogic {

	var currentScrollPos : CGFloat?

	weak var controller: FuelListLayoutViewLogic?

	@IBOutlet var baseView: UIView!
	@IBOutlet weak var inlineAlertView: InlineAlertView!
	@IBOutlet weak var tableViewNoDataView: TableViewNoDataView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet weak var savingsIconButton: UIButton!
	@IBOutlet weak var savingsLabelButton: UIButton!
	@IBOutlet weak var accuracyIconButton: UIButton!
	@IBOutlet weak var accuracyLabelButton: UIButton!

	@IBOutlet var closestCityNameButtonView: ClosestCityNameButtonView!

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

	deinit {
    	NotificationCenter.default.removeObserver(self, name: .dataDownloaderStateChange, object: nil)
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		tableView.layoutSubviews()
		tableView.layoutIfNeeded()
		adjustVisibilityOfShadowLines()
	}

	private func setup() {
		Bundle.main.loadNibNamed("FuelListLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		inlineAlertView.controller = self

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		inlineAlertView.translatesAutoresizingMaskIntoConstraints = false
		tableViewNoDataView.translatesAutoresizingMaskIntoConstraints = false
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

		closestCityNameButtonView.translatesAutoresizingMaskIntoConstraints = false

		closestCityNameButtonView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

		tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: inlineAlertView.bottomAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: savingsIconButton.topAnchor, constant: -15).isActive = true

		tableViewNoDataView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewNoDataView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewNoDataView.topAnchor.constraint(equalTo: inlineAlertView.bottomAnchor, constant: 60).isActive = true

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
    	tableView.contentInset = UIEdgeInsets(top: -2, left: 0, bottom: -9, right: 0)
    	let nib = UINib(nibName: "FuelListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
    	tableView.backgroundColor = UIColor.clear
    	
    	savingsLabelButton.titleLabel!.font = Font(.medium, size: .size3).font
		accuracyLabelButton.titleLabel!.font = Font(.medium, size: .size3).font

		savingsIconButton.addTarget(self, action: NSSelectorFromString("savingsButtonPressed"), for: .touchUpInside)
		accuracyIconButton.addTarget(self, action: NSSelectorFromString("accuracyButtonPressed"), for: .touchUpInside)
		savingsLabelButton.addTarget(self, action: NSSelectorFromString("savingsButtonPressed"), for: .touchUpInside)
		accuracyLabelButton.addTarget(self, action: NSSelectorFromString("accuracyButtonPressed"), for: .touchUpInside)

		NotificationCenter.default.addObserver(self, selector: #selector(dataDownloaderStateChange),
			name: .dataDownloaderStateChange, object: nil)

		tableViewNoDataView.alpha = 0
		adjustNoDataLabelText()

		closestCityNameButtonView.controller = self
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
			cell.iconImageView.sd_setImage(with: URL.init(string: aData.company.logoName ?? ""), placeholderImage: nil, options: .retryFailed) { (image, error, cacheType, url) in
//				if error != nil {
//					print("Failed: \(error)")
//				} else {
//					print("Success")
//				}
			}

			cell.priceLabel.text = aData.price
			
			if aData.isPriceCheapest == true {
				cell.priceLabel.textColor = UIColor(named: "CheapPriceColor")
			} else {
				cell.priceLabel.textColor = UIColor(named: "TitleColor")
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
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let aData = self.data[section].first!
			
		let baseView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: 60))
		
		let label: UILabel = UILabel()
		label.text = aData.fuelType.rawValue.localized()
		label.font = Font(.medium, size: .size3).font
		label.textColor = UIColor(named: "TitleColor")
		
		let height = aData.fuelType.rawValue.localized().height(withConstrainedWidth: self.frame.width-32, font: Font(.medium, size: .size3).font)
		
		label.frame = CGRect(x: 16, y: 20, width: self.frame.width-32, height: height+6)
		
		baseView.addSubview(label)
		
		return baseView
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		let aData = self.data[section].first!
		let height = aData.fuelType.rawValue.localized().height(withConstrainedWidth: self.frame.width-32, font: Font(.medium, size: .size3).font)
		
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

			tableView.scrollRectToVisible(CGRect(x: rect.origin.x, y: rect.origin.y-5, width: rect.width, height: rect.height + 10), animated: true)

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

		// Force the tableView to stay at scroll position until animation completes
		if (currentScrollPos != nil){
			tableView.setContentOffset(CGPoint(x: 0, y: currentScrollPos!), animated: false)
		}
	}

	// MARK: Functions

	@objc private func savingsButtonPressed() {
		controller?.savingsButtonPressed()
	}

	@objc private func accuracyButtonPressed() {
		controller?.accuracyButtonPressed()
	}

	private func adjustNoDataLabelText() {
		switch PricesDownloader.downloadingState {
			case .downloading:
				self.tableViewNoDataView.set(title: "no_data_label_downloading_active".localized(), loadingEnabled: true)
			case .downloaded:
				self.tableViewNoDataView.set(title: "no_data_label_no_data_available".localized(), loadingEnabled: false)
			case .parsingError:
				self.tableViewNoDataView.set(title: "no_data_label_parsing_problem".localized(), loadingEnabled: false)
			case .serverError:
				self.tableViewNoDataView.set(title: "no_data_label_server_error".localized(), loadingEnabled: false)
			case .timeout:
				self.tableViewNoDataView.set(title: "no_data_label_timeout".localized(), loadingEnabled: false)
		}
	}

	// MARK: FuelListLayoutViewDataLogic

	func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y-15))/50.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value+5))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]], insertItems: [IndexPath], deleteItems: [IndexPath], updateItems: [IndexPath], insertSections: [Int], deleteSections: [Int], updateSections: [Int]) {
//		print("data \(data)")
//		print("insertItems \(insertItems)")
//		print("deleteItems \(deleteItems)")
//		print("updateItems \(updateItems)")
//		print("insertSections \(insertSections)")
//		print("deleteSections \(deleteSections)")
//		print("updateSections \(updateSections)")

		if insertItems.isEmpty && deleteItems.isEmpty && updateItems.isEmpty && insertSections.isEmpty && deleteSections.isEmpty && updateSections.isEmpty {
			self.data = data
			tableView.reloadData()
			tableView.layoutIfNeeded()
		} else {
			self.data = data

			self.currentScrollPos = self.tableView.contentOffset.y

			tableView.performBatchUpdates({
				if !updateItems.isEmpty { tableView.reloadRows(at: updateItems, with: .left) }
				if !deleteItems.isEmpty { tableView.deleteRows(at: deleteItems, with: .fade) }
				if !insertItems.isEmpty { tableView.insertRows(at: insertItems, with: .fade) }
				if !insertSections.isEmpty { tableView.insertSections(IndexSet(insertSections), with: .fade) }
				if !deleteSections.isEmpty { tableView.deleteSections(IndexSet(deleteSections), with: .fade) }
				if !updateSections.isEmpty { tableView.reloadSections(IndexSet(updateSections), with: .fade) }

			}) { finished in
				self.adjustVisibilityOfShadowLines()
				self.currentScrollPos = nil
			}
		}

		savingsLabelButton.setTitle("fuel_list_savings_button_title".localized(), for: .normal)
		accuracyLabelButton.setTitle("fuel_list_fuel_price_accuracy_button_title".localized(), for: .normal)
		accuracyLabelButton.layoutIfNeeded()
		savingsLabelButton.layoutIfNeeded()

		if self.data.isEmpty {
			self.tableViewNoDataView.alpha = 1
			self.tableView.isScrollEnabled = false
		} else {
			self.tableViewNoDataView.alpha = 0
			self.tableView.isScrollEnabled = true
		}

		adjustVisibilityOfShadowLines()
	}

	func updateCity(_ name: String, gpsIconVisible: Bool) {
		closestCityNameButtonView.setCity(name: name, gpsIconVisible: gpsIconVisible)
		tableView.tableHeaderView = closestCityNameButtonView
	}

	func resetUI() {
		tableView.reloadData()
    	savingsLabelButton.titleLabel!.font = Font(.medium, size: .size3).font
		accuracyLabelButton.titleLabel!.font = Font(.medium, size: .size3).font
	}

	// MARK: Notifications

	@objc private func dataDownloaderStateChange() {
		adjustNoDataLabelText()
	}

	// MARK: InlineAlertViewLogic

	func inlineAlertViewFrameChanged() {
		adjustVisibilityOfShadowLines()
	}

	// MARK: ClosestCityNameButtonViewButtonLogic

	func closestCityNameButtonWasPressed() {
		controller?.closestCityNameButtonWasPressed()
	}
}
