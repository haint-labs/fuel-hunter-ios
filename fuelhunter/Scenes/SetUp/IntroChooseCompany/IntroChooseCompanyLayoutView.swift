//
//  IntroChooseCompanyLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol IntroChooseCompanyLayoutViewLogic {
	func switchWasPressedFor(companyName: String, withState state: Bool)
	func nextButtonWasPressed()
}

protocol IntroChooseCompanyLayoutViewDataLogic: class {
	func updateData(data: [IntroChooseCompany.CompanyCells.ViewModel.DisplayedCompanyCellItem], insert: [IndexPath], delete: [IndexPath], update: [IndexPath])
}

class IntroChooseCompanyLayoutView: FontChangeView, UITableViewDataSource, UITableViewDelegate, IntroChooseCompanyLayoutViewDataLogic, FuelCompanyListCellSwitchLogic {

	weak var controller: IntroChooseCompanyViewController? 

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var topTitleLabel: UILabel!
	@IBOutlet weak var tableViewNoDataView: TableViewNoDataView!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet weak var nextButton: UIButton!

	var data = [IntroChooseCompany.CompanyCells.ViewModel.DisplayedCompanyCellItem]()

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
	
	func setup() {
		Bundle.main.loadNibNamed("IntroChooseCompanyLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
		tableViewNoDataView.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false
		nextButton.translatesAutoresizingMaskIntoConstraints = false

		topTitleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 30).isActive = true
		topTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
		topTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true

		tableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableView.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 10).isActive = true

		tableViewNoDataView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewNoDataView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewNoDataView.topAnchor.constraint(equalTo: topTitleLabel.bottomAnchor, constant: 30).isActive = true


		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1).isActive = true

		nextButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		nextButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		nextButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 10).isActive = true
		nextButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50).isActive = true

		topTitleLabel.text = "intro_choose_companies_you_use_title".localized()
		nextButton.setTitleColor(UIColor(named: "DisabledButtonColor"), for: .disabled)
		nextButton.setTitle("next_button_title".localized(), for: .normal)
		nextButton.addTarget(self, action:NSSelectorFromString("nextButtonPressed"), for: .touchUpInside)

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
    	let nib = UINib(nibName: "FuelCompanyListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
		tableView.backgroundColor = UIColor.clear
		tableViewNoDataView.alpha = 0

  		updateFonts()

		NotificationCenter.default.addObserver(self, selector: #selector(dataDownloaderStateChange),
    		name: .dataDownloaderStateChange, object: nil)

		adjustNoDataLabelText()
    }

	func updateFonts() {
		topTitleLabel.font = Font(.normal, size: .size2).font
		nextButton.titleLabel?.font = Font(.medium, size: .size2).font
	}

	override func fontSizeWasChanged() {
		updateFonts()
		tableView.reloadData()
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
			print("problem")
			return UITableViewCell()
		}
	}

	func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
		return 0
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
		let value = tableView.contentOffset.y+tableView.frame.size.height-tableView.contentInset.bottom-tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value-15))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

  	@objc func nextButtonPressed() {
		controller?.nextButtonWasPressed()
  	}

	// MARK: FuelCompanyListCellSwitchLogic

	func switchWasPressedOnTableViewCell(cell: FuelCompanyListCell, withState state: Bool) {
		if let indexPath = tableView.indexPath(for: cell) {
			let aData = data[indexPath.row] as IntroChooseCompany.CompanyCells.ViewModel.DisplayedCompanyCellItem
			controller?.switchWasPressedFor(companyName: aData.title, withState: state)
		}
	}
	
  	// MARK: IntroChooseCompanyLayoutViewDataLogic

	func updateData(data: [IntroChooseCompany.CompanyCells.ViewModel.DisplayedCompanyCellItem], insert: [IndexPath], delete: [IndexPath], update: [IndexPath]) {

		if delete.isEmpty && insert.isEmpty && update.isEmpty {
			self.data = data
			tableView.reloadData()
		} else {
			self.data = data

			tableView.performBatchUpdates({
				if !delete.isEmpty { tableView.deleteRows(at: delete, with: .fade) }
				if !insert.isEmpty { tableView.insertRows(at: insert, with: .fade) }
				if !update.isEmpty { tableView.reloadRows(at: update, with: .fade) }
			}) { finished in self.adjustVisibilityOfShadowLines() }

			tableView.performBatchUpdates({
				if !update.isEmpty { tableView.reloadRows(at: update, with: .none) }
			})
		}

		self.nextButton.isEnabled = !self.data.isEmpty

		if self.data.isEmpty {
			self.tableViewNoDataView.alpha = 1
			self.tableView.isUserInteractionEnabled = false
		} else {
			self.tableViewNoDataView.alpha = 0
			self.tableView.isUserInteractionEnabled = true
		}

		adjustVisibilityOfShadowLines()
	}

	func adjustNoDataLabelText() {
		switch CompaniesDownloader.downloadingState {
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

	// MARK: Notifications

	@objc func dataDownloaderStateChange() {
		adjustNoDataLabelText()
	}
}
