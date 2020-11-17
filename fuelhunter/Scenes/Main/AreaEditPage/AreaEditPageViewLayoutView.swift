//
//  AreaEditPageViewLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol AreaEditPageViewLayoutViewLogic: class {
	func userJustChangedAreaName(_ name: String)
	func userJustToggledCheapestOnlySwitch(withState state: Bool)
	func userJustToggledPushNotifSwitch(withState state: Bool)
	func deleteWasPressed()
}

protocol AreaEditPageViewLayoutViewDataLogic: class {
	func updateData(data: [[Area.AreaEditPage.ViewModel.DisplayedCell]])
}

class AreaEditPageViewLayoutView: UIView, UITableViewDataSource, UITableViewDelegate, AreaEditPageViewLayoutViewDataLogic, AreaEditPageCellDataLogic {

	weak var controller: AreaEditPageViewLayoutViewLogic?

	@IBOutlet var baseView: UIView!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var tableViewTopShadow: UIImageView!
	@IBOutlet var tableViewBottomShadow: UIImageView!

	var data = [[Area.AreaEditPage.ViewModel.DisplayedCell]]()

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
		Bundle.main.loadNibNamed("AreaEditPageViewLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		tableView.keyboardDismissMode = .interactive

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
    	tableView.contentInset = UIEdgeInsets(top: 9, left: 0, bottom: -20, right: 0)
		tableView.backgroundColor = .white

    	let nib = UINib(nibName: "AreaEditPageCell", bundle: nil)
    	tableView.register(nib, forCellReuseIdentifier: "cell")

    	let nibHeader = UINib(nibName: "AreaEditPageHeaderView", bundle: nil)
		self.tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "header")

    	NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
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
		) as? AreaEditPageCell {
			let aDataSection = self.data[indexPath.section]
			let aData = aDataSection[indexPath.row]

			cell.selectionStyle = .none
			cell.controller = self

			cell.titleTextField.text = aData.name
			cell.titleLabel.text = aData.name
			cell.descriptionLabel.text = aData.description

			cell.setAccessoryIconType(type: aData.accessoryType, toggleOrCheckmarkIsOn: aData.toggleOrCheckmarkIsOn)

			if aDataSection.count == 1 {
				cell.setAsCellType(cellType: .single)
			} else {
				if aDataSection.first == aData {
					cell.setAsCellType(cellType: .top)
				} else if aDataSection.last == aData {
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

		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! AreaEditPageHeaderView

		header.titleLabel.text = " "

		if section == 1 {
			header.titleLabel.text = "areas_section_companies_in_radius".localized()
		} else if section == 2 {
			header.titleLabel.text = "areas_section_other_options".localized()
		}

		header.setSectionIndex(section)

		header.backgroundColor = .red
        return header
	}

	func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
		return 0
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Let nothing happen when we press gps or notif cell.
		let aData = self.data[indexPath.section][indexPath.row]

		if aData.functionalityType == .cellFunctionalityTypeName {
			let cell = self.tableView.cellForRow(at: indexPath) as! AreaEditPageCell
			cell.activateTextField()
		} else if aData.functionalityType == .cellFunctionalityTypeDelete {
			controller?.deleteWasPressed()
		}
	}

  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		adjustVisibilityOfShadowLines()
	}

	// MARK: Functions

	private func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y+15))/50.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y + tableView.frame.size.height - tableView.contentInset.bottom - tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value-15))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

	// MARK: AreaEditPageViewLayoutViewDataLogic

	func updateData(data: [[Area.AreaEditPage.ViewModel.DisplayedCell]]) {

		if self.data.isEmpty {
			self.data = data
			tableView.reloadData()
  		} else {
			self.data = data
  		}
	}

	// MARK: AreaEditPageCellDataLogic

	func textFieldShouldResign(cell: AreaEditPageCell) {
		if Int(-self.tableView.contentOffset.y) != Int(self.tableView.contentInset.top) {
			UIView.animate (withDuration: 0.3, animations: {
				self.tableView.scrollToRow(at: IndexPath.init(row: 0, section: 0), at: .top, animated: false)
			}) { (_) in
				cell.titleTextField.resignFirstResponder()
			}
		} else {
			cell.titleTextField.resignFirstResponder()
		}

		controller?.userJustChangedAreaName(cell.titleTextField.text!)
	}

	func switchWasPressedOnTableViewCell(cell: AreaEditPageCell, withState state: Bool) {
		let indexPath = self.tableView.indexPath(for: cell)!
		let aData = self.data[indexPath.section][indexPath.row]

		if aData.functionalityType == .cellFunctionalityTypeCheapestOnly {
			controller?.userJustToggledCheapestOnlySwitch(withState: state)
		} else if aData.functionalityType == .cellFunctionalityTypePushNotif {
			controller?.userJustToggledPushNotifSwitch(withState: state)
		}
	}

	// MARK: Keyboard

	@objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {

			UIView.animate(withDuration: 0.35, animations: {
				self.tableView.contentInset = UIEdgeInsets(top: 9, left: 0, bottom: keyboardSize.height + -20 + -self.superview!.safeAreaInsets.bottom, right: 0)
//				self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: keyboardSize.height + 12 + -self.superview!.safeAreaInsets.bottom, right: 0)
				self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + -self.superview!.safeAreaInsets.bottom, right: 0)
			});
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
    	UIView.animate(withDuration: 0.35, animations: {
//    		self.tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
    		self.tableView.contentInset = UIEdgeInsets(top: 9, left: 0, bottom: -20, right: 0)
				self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		});
    }
}
