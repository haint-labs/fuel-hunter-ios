//
//  CompaniesChooseListLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol CompaniesChooseListLayoutViewLogic: class {
	func switchWasPressedFor(companyType: CompanyType, withState state: Bool)
}

protocol CompaniesChooseListLayoutViewDataLogic: class {
	func updateData(data: [CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem])
}

class CompaniesChooseListLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, FuelCompanyListCellSwitchLogic, CompaniesChooseListLayoutViewDataLogic {

	weak var controller: CompaniesChooseListLayoutViewLogic? 

	@IBOutlet var baseView: UIView!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var tableViewTopShadow: UIImageView!
	@IBOutlet var tableViewBottomShadow: UIImageView!

  	var header: UIView!

	var data = [CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem]()

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
		Bundle.main.loadNibNamed("CompaniesChooseListLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false

		tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		tableView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1).isActive = true

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
    	let nib = UINib(nibName: "FuelCompanyListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")

    	setUpTableViewHeader()
  	}

  	func setUpTableViewHeader() {
		header = UIView()

		let label = UILabel()
		label.numberOfLines = 0
		label.textAlignment = .center
		label.font = Font(.normal, size: .size2).font
		label.textColor = UIColor(named: "TitleColor")
		let text = "company_select_companies_you_wish_to_be_represented_title".localized()
		let height = text.height(withConstrainedWidth: self.frame.width-26, font: label.font)
		label.text = text
		label.frame = CGRect(x: 12, y: 10, width: self.frame.width-26, height: height+6)
		header.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: height+26)
		header.addSubview(label)
		tableView.tableHeaderView = header
	}

  	// MARK: Table view

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelCompanyListCell {
			let aData = self.data[indexPath.row]
			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title.localized()
			cell.aSwitch.isOn = aData.toggleStatus
			cell.setIconImageFromImageName(imageName: aData.imageName)
			cell.setDescriptionText(descriptionText: aData.description.localized())
			cell.controller = self
			if self.data.count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if self.data.first == aData {
					cell.setAsCellType(cellType: .top)
				} else if self.data.last == aData {
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

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
	}

  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		adjustVisibilityOfShadowLines()
	}

	// MARK: Functions

	func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y+15))/50.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y + tableView.frame.size.height - tableView.contentInset.bottom - tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value-15))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

	// MARK: FuelCompanyListCellSwitchLogic

  	func switchWasPressedOnTableViewCell(cell: FuelCompanyListCell, withState state: Bool) {
		let indexPath = tableView.indexPath(for: cell)
		let aData = data[indexPath!.row] as CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem
		controller?.switchWasPressedFor(companyType: aData.companyType, withState: state)
	}

	// MARK: CompaniesChooseListLayoutViewDataLogic

	func updateData(data: [CompaniesChooseList.CompanyCells.ViewModel.DisplayedCompanyCellItem]) {
		if self.data.count == 0 {
			self.data = data
			tableView.reloadData()
		} else {
			self.data = data
			if self.data.count > 0 {
				guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? FuelCompanyListCell else { return }
				if self.data.first?.toggleStatus != cell.aSwitch.isOn {
					// Without this - tableview jumps.
					UIView.setAnimationsEnabled(false)
					tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .fade)
					UIView.setAnimationsEnabled(true)
				}
			}
		}
	}
}
