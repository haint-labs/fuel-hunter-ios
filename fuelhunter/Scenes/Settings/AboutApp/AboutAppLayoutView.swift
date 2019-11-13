//
//  AboutAppLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol AboutAppLayoutViewDataLogic: class {
	func appMovedToForeground()
	func appMovedToBackground()
	func updateData(data: [AboutApp.CompanyCells.ViewModel.DisplayedCompanyCellItem])
}

class AboutAppLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, AboutAppLayoutViewDataLogic {

	@IBOutlet var baseView: UIView!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var tableViewTopShadow: UIImageView!
	@IBOutlet var tableViewBottomShadow: UIImageView!

  	var header: UIView!

	var data = [AboutApp.CompanyCells.ViewModel.DisplayedCompanyCellItem]()

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
		Bundle.main.loadNibNamed("AboutAppLayoutView", owner: self, options: nil)
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
    	tableView.contentInset = UIEdgeInsets.init(top: 16, left: 0, bottom: 12, right: 0)
    	let nib = UINib.init(nibName: "AboutAppFuelCompanyCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")

    	setUpTableViewHeader()
  	}

  	func setUpTableViewHeader() {
		header = AboutAppTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 100))
		header.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.tableHeaderView = header
		header.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
		header.layoutIfNeeded()
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
		) as? AboutAppFuelCompanyCell {
			let aData = self.data[indexPath.row]
			cell.selectionStyle = .none
			cell.titleLabel.text = aData.title
			cell.descriptionLabel.text = aData.description.localized()
			cell.iconImageView.image = UIImage.init(named: aData.imageName)

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
		let value = tableView.contentOffset.y + tableView.frame.size.height - tableView.contentInset.bottom - tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value-15))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

	// MARK: AboutAppLayoutViewDataLogic

	func appMovedToForeground() {
		(header as! AboutAppTableHeaderView).startAnimations()
	}

	func appMovedToBackground() {
		(header as! AboutAppTableHeaderView).stopAnimations()
	}

	func updateData(data: [AboutApp.CompanyCells.ViewModel.DisplayedCompanyCellItem]) {
		self.data = data
    	tableView.reloadData()
		tableView.layoutIfNeeded()
	}	
}
