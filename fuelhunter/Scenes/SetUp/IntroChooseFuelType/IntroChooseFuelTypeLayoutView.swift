//
//  IntroChooseFuelTypeLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol IntroChooseFuelTypeLayoutViewLogic {
	func switchWasPressedFor(fuelType: FuelType, withState state: Bool)
	func nextButtonWasPressed()
}

protocol IntroChooseFuelTypeLayoutViewDataLogic: class {
	func updateData(data: [IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem])
	func setNextButtonAsEnabled(_ isEnabled: Bool)
}

class IntroChooseFuelTypeLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, IntroChooseFuelTypeLayoutViewDataLogic, FuelTypeListCellSwitchLogic {

	weak var controller: IntroChooseFuelTypeViewController? 

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var topTitleLabel: UILabel!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var tableViewTopShadow: UIImageView!
	@IBOutlet weak var tableViewBottomShadow: UIImageView!
	@IBOutlet weak var nextButton: UIButton!

	var data = [IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem]()

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
		Bundle.main.loadNibNamed("IntroChooseFuelTypeLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		topTitleLabel.translatesAutoresizingMaskIntoConstraints = false
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

		topTitleLabel.text = "Atzīmē degvielas veidus, kuru cenas Tev interesē."
		nextButton.setTitle("Tālāk", for: .normal)
		topTitleLabel.font = Font.init(.normal, size: .size2).font
		nextButton.titleLabel?.font = Font.init(.medium, size: .size2).font
		nextButton.setTitleColor(UIColor.init(named: "DisabledButtonColor"), for: .disabled)
		nextButton.addTarget(self, action:NSSelectorFromString("nextButtonPressed"), for: .touchUpInside)

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 12, right: 0)
    	let nib = UINib.init(nibName: "FuelTypeListCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")
  	}

  	// MARK: Table view

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return data.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? FuelTypeListCell {
			let aData = self.data[indexPath.row]
			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title
			cell.aSwitch.isOn = aData.toggleStatus
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
			return UITableViewCell.init()
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

  	// MARK: functions

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

  	// MARK: IntroChooseFuelTypeLayoutViewDataLogic

  	func updateData(data: [IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem]) {
  		if self.data.count == 0 {
			self.data = data
			tableView.reloadData()
		} else {
			self.data = data
		}
  	}

  	func setNextButtonAsEnabled(_ isEnabled: Bool) {
  		nextButton.isEnabled = isEnabled
  	}

  	// MARK: FuelTypeListCellSwitchLogic

  	func switchWasPressedOnTableViewCell(cell: FuelTypeListCell, withState state: Bool) {
		let indexPath = tableView.indexPath(for: cell)
		let aData = data[indexPath!.row] as IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem
		controller?.switchWasPressedFor(fuelType: aData.fuelType, withState: state)
	}
}
