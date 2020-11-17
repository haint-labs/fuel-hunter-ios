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
	func settingsButtonPressed()
	func pressedOnACell(atYLocation yLocation: CGFloat, forCell cell: FuelListCell, forCompany company: CompanyEntity, forSelectedFuelType fuelType: FuelType, forSelectedPrice price: PriceEntity)
}

protocol FuelListLayoutViewDataLogic: class {
	func adjustVisibilityOfShadowLines()
	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]], insertItems: [IndexPath], deleteItems: [IndexPath], updateItems: [IndexPath], insertSections: [Int], deleteSections: [Int], updateSections: [Int])
	func updateCity(_ name: String, gpsIconVisible: Bool)
	func resetUI()
	func scrollToTop()
}

class FuelListLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, FuelListLayoutViewDataLogic {

	var currentScrollPos : CGFloat?

	weak var controller: FuelListLayoutViewLogic?
	weak var superParentView: UIView!

	@IBOutlet var baseView: UIView!
	@IBOutlet weak var tableViewNoDataView: TableViewNoDataView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet var cityNameView: ClosestCityNameButtonView!

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
//		print("tableView.window \(tableView.window)")
		tableView.layoutSubviews()
		tableView.layoutIfNeeded()
		adjustVisibilityOfShadowLines()
	}

	private func setup() {
		Bundle.main.loadNibNamed("FuelListLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		tableViewNoDataView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false
		cityNameView.translatesAutoresizingMaskIntoConstraints = false

		cityNameView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
		cityNameView.topAnchor.constraint(equalTo: topAnchor).isActive = true

		tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: cityNameView.bottomAnchor, constant: 20).isActive = true
		tableView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1).isActive = true

		tableViewNoDataView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewNoDataView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewNoDataView.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true

		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: cityNameView.bottomAnchor, constant: 20).isActive = true

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets(top: -2, left: 0, bottom: -17, right: 0)
    	let nib = UINib(nibName: "FuelListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
    	let nibHeader = UINib(nibName: "FuelListHeaderView", bundle: nil)
		self.tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "header")
    	tableView.backgroundColor = UIColor.clear

    	
		NotificationCenter.default.addObserver(self, selector: #selector(dataDownloaderStateChange),
			name: .dataDownloaderStateChange, object: nil)

		tableViewNoDataView.alpha = 0
		adjustNoDataLabelText()

		
		
//		_  = cityNameView.setCity(name: "Rīga", gpsIconVisible: true)
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

			if(self.data.count-1 >= indexPath.section && self.data[indexPath.section].count-1 >= indexPath.row) {
				let aData = self.data[indexPath.section][indexPath.row]
				cell.titleLabel.text = aData.company.name
				cell.addressesLabel.text = aData.addressDescription
				cell.setImageWithName(aData.company.logoName)
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
			}

			return cell
		} else {
			// Problem
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! FuelListHeaderView

		if(self.data.count-1 >= section && self.data[section].count-1 >= 0) {
			let aData = self.data[section].first!
			header.titleLabel.text = aData.fuelType.rawValue.localized()
		} else {
			header.titleLabel.text = " "
		}

		header.setSectionIndex(section)
		
        return header
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// TODO: check if cell is partly visible. If yes, then first scroll to visible, and then select it?
		let aData = self.data[indexPath.section][indexPath.row]

		let rect = tableView.rectForRow(at: indexPath)
		let rectInScreen = tableView.convert(rect, to: self.superParentView)
		
		if !tableView.bounds.contains(rect) {
			// Cell is partly visible. So we scroll to reveal it fully. Just a nicety

			tableView.scrollRectToVisible(CGRect(x: rect.origin.x, y: rect.origin.y-5, width: rect.width, height: rect.height + 10), animated: true)

			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { 
				let rect = tableView.rectForRow(at: indexPath)
				let rectInScreen = tableView.convert(rect, to: self.superParentView)
				let cell = tableView.cellForRow(at: indexPath) as! FuelListCell

				self.controller?.pressedOnACell(atYLocation: rectInScreen.origin.y, forCell: cell, forCompany: aData.company, forSelectedFuelType: aData.fuelType, forSelectedPrice: aData.actualPrice)
			}
		} else {
			let cell = tableView.cellForRow(at: indexPath) as! FuelListCell

			controller?.pressedOnACell(atYLocation: rectInScreen.origin.y, forCell: cell, forCompany: aData.company, forSelectedFuelType: aData.fuelType, forSelectedPrice: aData.actualPrice)
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

	private func adjustNoDataLabelText() {
		if(PricesDownloader.isAllowedToDownload() == false && PricesDownloader.shouldInitiateDownloadWhenPossible() == true) {
			self.tableViewNoDataView.set(title: "no_data_label_downloading_active".localized(), loadingEnabled: true)
		} else {
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
	}

	// MARK: FuelListLayoutViewDataLogic

	func adjustVisibilityOfShadowLines() {
		let alfa = min(25, max(0, tableView.contentOffset.y-15+12))/25
		tableViewTopShadow.alpha = alfa

//		print("alfa \(alfa)")
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top
		let alfa2 = min(25, max(0, tableView.contentSize.height-value))/25
		tableViewBottomShadow.alpha = alfa2
	}

	func updateData(data: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]], insertItems: [IndexPath], deleteItems: [IndexPath], updateItems: [IndexPath], insertSections: [Int], deleteSections: [Int], updateSections: [Int]) {

//		print("data \(data)")
		print("insertItems \(insertItems)")
		print("deleteItems \(deleteItems)")
		print("updateItems \(updateItems)")
		print("insertSections \(insertSections)")
		print("deleteSections \(deleteSections)")
		print("updateSections \(updateSections)")

		if insertItems.isEmpty && deleteItems.isEmpty && updateItems.isEmpty && insertSections.isEmpty && deleteSections.isEmpty && updateSections.isEmpty {
			self.data = data
			tableView.reloadData()
//			tableView.layoutSubviews()
//			tableView.layoutIfNeeded()
		} else {
			self.data = data

//			UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve, animations: {
//				self.tableView.reloadData()
//			}) { (success) in
//				self.adjustVisibilityOfShadowLines()
//			}


			self.currentScrollPos = self.tableView.contentOffset.y

//			tableView.reloadData()
			
			tableView.performBatchUpdates({
				if !deleteItems.isEmpty { tableView.deleteRows(at: deleteItems, with: .fade) }
				if !insertItems.isEmpty { tableView.insertRows(at: insertItems, with: .fade) }
				if !updateItems.isEmpty { tableView.reloadRows(at: updateItems, with: .fade) }
				if !deleteSections.isEmpty { tableView.deleteSections(IndexSet(deleteSections), with: .fade) }
				if !insertSections.isEmpty { tableView.insertSections(IndexSet(insertSections), with: .fade) }
				if !updateSections.isEmpty { tableView.reloadSections(IndexSet(updateSections), with: .fade) }

			}) { finished in
				self.adjustVisibilityOfShadowLines()
				self.currentScrollPos = nil
			}
		}

		if self.data.isEmpty {
			self.tableViewNoDataView.alpha = 1
			self.tableView.isScrollEnabled = false
		} else {
			self.tableViewNoDataView.alpha = 0
			self.tableView.isScrollEnabled = true
		}

		DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
			self.adjustVisibilityOfShadowLines()
		}
	}

	func updateCity(_ name: String, gpsIconVisible: Bool) {
		_ = cityNameView.setCity(name: name, gpsIconVisible: gpsIconVisible)
	}

	func resetUI() {
		tableView.reloadData()
	}


	func scrollToTop() {
		tableView.setContentOffset(CGPoint.init(x: 0, y: tableView.contentInset.top * -1), animated: false)
	}

	// MARK: Notifications

	@objc private func dataDownloaderStateChange() {
		adjustNoDataLabelText()
	}
}
