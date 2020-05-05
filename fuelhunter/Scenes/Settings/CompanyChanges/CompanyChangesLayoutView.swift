//
//  CompanyChangesLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol CompanyChangesLayoutViewLogic: class {
	func switchWasPressedFor(companyName: String, withState state: Bool)
	func dismissButtonPressed()
}

protocol CompanyChangesLayoutViewDataLogic: class {
	func animateBackgroundImageColorToState(visible: Bool)
	func updateData(data: CompanyChanges.List.ViewModel)
}

class CompanyChangesLayoutView: UIView, CompanyChangesLayoutViewDataLogic, UITableViewDataSource, UITableViewDelegate, FuelCompanyListCellSwitchLogic {

	weak var controller: CompanyChangesLayoutViewLogic?

	@IBOutlet weak var backgroundView: UIView!
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var tableView: ContentSizedTableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet weak var dismissButton: UIButton!
	@IBOutlet var backgroundDismissButton: UIButton!

	var tableViewHeightConstraint: NSLayoutConstraint!

	var companyData = [[CompanyChanges.List.ViewModel.DisplayedCompanyCellItem]]()
	
	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		adjustVisibilityOfShadowLines()
	}

	private func setup() {
		Bundle.main.loadNibNamed("CompanyChangesLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		baseView.backgroundColor = .clear

		self.translatesAutoresizingMaskIntoConstraints = false

		frontView.translatesAutoresizingMaskIntoConstraints = false
		backgroundView.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
  		titleLabel.translatesAutoresizingMaskIntoConstraints = false
  		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false
  		dismissButton.translatesAutoresizingMaskIntoConstraints = false
		backgroundDismissButton.translatesAutoresizingMaskIntoConstraints = false

  		baseView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		backgroundDismissButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundDismissButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
		backgroundDismissButton.addTarget(self, action: NSSelectorFromString("dismissButtonPressed"), for: .touchUpInside)

  		backgroundView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundView.heightAnchor.constraint(equalTo: self.heightAnchor, constant: 6000).isActive = true
  		backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -3000).isActive = true

		frontView.topAnchor.constraint(greaterThanOrEqualTo: self.topAnchor, constant: 10).isActive = true
		frontView.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor, constant: -35).isActive = true
  		let yconstraint = frontView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -40)
		yconstraint.priority = .defaultHigh
		yconstraint.isActive = true

  		frontView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
  		frontView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true


  		titleLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 20).isActive = true
  		titleLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 30).isActive = true
  		titleLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -30).isActive = true

		tableView.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true


		tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.contentSize.height)
		tableViewHeightConstraint.priority = .defaultLow
		tableViewHeightConstraint.isActive = true


		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true
		

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1).isActive = true

  		dismissButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 14).isActive = true
  		dismissButton.centerXAnchor.constraint(equalTo: frontView.centerXAnchor).isActive = true
  		dismissButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -20).isActive = true

  		frontView.backgroundColor = .white
  		frontView.layer.cornerRadius = 10
  		frontView.layer.shadowColor = UIColor(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 0.44).cgColor
  		frontView.layer.shadowOpacity = 1
  		frontView.layer.shadowRadius = 8

  		titleLabel.font = Font(.medium, size: .size1).font
  		dismissButton.setTitle("ok_button_title".localized(), for: .normal)
  		dismissButton.titleLabel?.font = Font(.medium, size: .size2).font

  		backgroundView.backgroundColor = .clear
  		dismissButton.addTarget(self, action: NSSelectorFromString("dismissButtonPressed"), for: .touchUpInside)

  		tableView.delegate = self
    	tableView.dataSource = self
    	let nib = UINib(nibName: "FuelCompanyListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
    	let nibHeader = UINib(nibName: "TextTableViewHeaderView", bundle: nil)
		self.tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "header")
		tableView.backgroundColor = UIColor.clear
		tableView.scrollIndicatorInsets.right = 2

		// Otherwise for some reason, for grouped tableview, footer view is 20 pix or smth.
		let footerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 1, height: 1))
		tableView.tableFooterView = footerView
		// And this will offset the footerView. Setting footerView to .zero did not work.
    	tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -1, right: 0)
  	}

  	// MARK: Table view

	func numberOfSections(in tableView: UITableView) -> Int {
		return companyData.count
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return companyData[section].count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelCompanyListCell {
			let aSectionData = companyData[indexPath.section]
			let aData = companyData[indexPath.section][indexPath.row]

			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title.localized()
			cell.aSwitch.isOn = aData.toggleStatus
			cell.setIconImageFromImageName(imageName: aData.imageName)
			cell.setDescriptionText(descriptionText: aData.description.localized())
			cell.setSwitchAsVisible(aData.companyWasAdded)
			cell.controller = self
			
			if aSectionData.count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if aSectionData.first == aData {
					cell.setAsCellType(cellType: .top)
				} else if aSectionData.last == aData {
					cell.setAsCellType(cellType: .bottom)
				} else {
					cell.setAsCellType(cellType: .middle)
				}
			}

			return cell
		} else {
			// Problem
			print("problem")
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! TextTableViewHeaderView

		let aSectionData = companyData[section]
		let aData = companyData[section].first!

		if aData.companyWasAdded == true {
			if aSectionData.count == 1 {
				header.titleLabel.text = "settings_changes_new_company_section_title".localized()
			} else {
				header.titleLabel.text = "settings_changes_new_companies_section_title".localized()
			}
		} else {
			if aSectionData.count == 1 {
				header.titleLabel.text = "settings_changes_removes_company_section_title".localized()
			} else {
				header.titleLabel.text = "settings_changes_removes_companies_section_title".localized()
			}
		}

		header.setSectionIndex(section)

        return header
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

	private func adjustVisibilityOfShadowLines() {
		let alfa = min(15, max(0, tableView.contentOffset.y + tableView.contentInset.top))/15.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top
		let alfa2 = min(15, max(0, tableView.contentSize.height - value - tableView.contentInset.top))/15.0
		tableViewBottomShadow.alpha = alfa2
	}

  	@objc private func dismissButtonPressed() {
  		controller?.dismissButtonPressed()
  	}

	// MARK: FuelCompanyListCellSwitchLogic

	func switchWasPressedOnTableViewCell(cell: FuelCompanyListCell, withState state: Bool) {
		if let indexPath = tableView.indexPath(for: cell) {
			let aData = companyData[indexPath.section][indexPath.row] as CompanyChanges.List.ViewModel.DisplayedCompanyCellItem
			controller?.switchWasPressedFor(companyName: aData.title, withState: state)
		}
	}

	// MARK: CompanyChangesLayoutViewDataLogic

	func animateBackgroundImageColorToState(visible: Bool) {
		if visible {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = UIColor(named: "PopUpBackground")
			}, completion: { (finished: Bool) in self.adjustVisibilityOfShadowLines() })
		} else {
			UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {
				self.backgroundView.backgroundColor = .clear
			}, completion: { (finished: Bool) in })
		}
	}

	func updateData(data: CompanyChanges.List.ViewModel) {
		companyData = data.displayedCompanyCellItems
		titleLabel.text = "settings_changes_title".localized()
		tableView.reloadData()
		self.layoutSubviews()
	}
}
