//
//  AreaSetUpPage2LayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol AreaSetUpPage2LayoutViewLogic: class {
	func backButtonPressed()
	func saveButtonPressed()
	func selectedCityWithName(_ name: String)
	func toggleCompanyNamed(name: String, state: Bool)
	func userToggledCheapestPrice(to state: Bool)
}

protocol AreaSetUpPage2LayoutViewDataLogic: class {
	func updateData(data: [[AreaSetUpPage.AreaEditPage.ViewModel.DisplayedCell]], name: String)
	func updateFrontFrame(to frame: CGRect)
}

class AreaSetUpPage2LayoutView: UIView, AreaSetUpPage2LayoutViewDataLogic, UITableViewDataSource, UITableViewDelegate, AreaEditPageCellDataLogic {

	weak var controller: AreaSetUpPage2LayoutViewLogic?

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet var descriptionCityLabel: UILabel!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var backgroundDismissButton: UIButton!

	@IBOutlet var tableViewTopShadow: UIImageView!
	@IBOutlet var tableViewBottomShadow: UIImageView!

	@IBOutlet var saveButton: UIButton!

	var data = [[AreaSetUpPage.AreaEditPage.ViewModel.DisplayedCell]]()

	var frontViewTopConstraint: NSLayoutConstraint!
	var frontViewLeftConstraint: NSLayoutConstraint!
	var frontViewWidthConstraint: NSLayoutConstraint!
	var frontViewHeightConstraint: NSLayoutConstraint!

	var descriptionRightConstraint: NSLayoutConstraint!

	var keyboardHeight: CGFloat = 0

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
		NotificationCenter.default.removeObserver(self)
	}

	private func setup() {
		Bundle.main.loadNibNamed("AreaSetUpPage2LayoutView", owner: self, options: nil)
		addSubview(baseView)
		self.backgroundColor = .clear
		baseView.frame = self.bounds
		baseView.backgroundColor = .clear

		self.translatesAutoresizingMaskIntoConstraints = false
		frontView.translatesAutoresizingMaskIntoConstraints = false
  		baseView.translatesAutoresizingMaskIntoConstraints = false
  		descriptionCityLabel.translatesAutoresizingMaskIntoConstraints = false
		backButton.translatesAutoresizingMaskIntoConstraints = false
		tableView.translatesAutoresizingMaskIntoConstraints = false
		backgroundDismissButton.translatesAutoresizingMaskIntoConstraints = false
		tableViewTopShadow.translatesAutoresizingMaskIntoConstraints = false
		tableViewBottomShadow.translatesAutoresizingMaskIntoConstraints = false
		saveButton.translatesAutoresizingMaskIntoConstraints = false


  		baseView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		baseView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		backgroundDismissButton.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
  		backgroundDismissButton.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true

		backgroundDismissButton.addTarget(self, action: NSSelectorFromString("backButtonPressed"), for: .touchUpInside)

		frontViewTopConstraint = frontView.topAnchor.constraint(equalTo: self.topAnchor)
		frontViewLeftConstraint = frontView.leftAnchor.constraint(equalTo: self.leftAnchor)
		frontViewWidthConstraint = frontView.widthAnchor.constraint(equalToConstant: 200)
		frontViewHeightConstraint = frontView.heightAnchor.constraint(equalToConstant: 300)

		frontViewTopConstraint.isActive = true
		frontViewLeftConstraint.isActive = true
		frontViewWidthConstraint.isActive = true
		frontViewHeightConstraint.isActive = true

		descriptionCityLabel.topAnchor.constraint(equalTo: frontView.topAnchor, constant: 16).isActive = true
  		descriptionCityLabel.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 40).isActive = true
  		descriptionRightConstraint = descriptionCityLabel.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -40)

		backButton.topAnchor.constraint(equalTo: descriptionCityLabel.topAnchor).isActive = true
		backButton.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 0).isActive = true
		backButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
		backButton.bottomAnchor.constraint(equalTo: descriptionCityLabel.bottomAnchor).isActive = true

		tableView.topAnchor.constraint(equalTo: descriptionCityLabel.bottomAnchor, constant: 16).isActive = true
  		tableView.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableView.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true

		tableViewTopShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewTopShadow.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableViewTopShadow.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true
		tableViewTopShadow.topAnchor.constraint(equalTo: tableView.topAnchor).isActive = true

		tableViewBottomShadow.heightAnchor.constraint(equalToConstant: 3).isActive = true
		tableViewBottomShadow.leftAnchor.constraint(equalTo: frontView.leftAnchor).isActive = true
		tableViewBottomShadow.rightAnchor.constraint(equalTo: frontView.rightAnchor).isActive = true
		tableViewBottomShadow.bottomAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 1).isActive = true


		saveButton.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: 15).isActive = true
  		saveButton.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -20).isActive = true
  		saveButton.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 20).isActive = true
  		saveButton.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: -15).isActive = true


		descriptionRightConstraint.isActive = true


  		frontView.backgroundColor = .white
  		frontView.layer.cornerRadius = 10
  		frontView.layer.shadowColor = UIColor(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 0.44).cgColor
  		frontView.layer.shadowOpacity = 1
  		frontView.layer.shadowRadius = 8

  		descriptionCityLabel.font = Font(.normal, size: .size2).font
		saveButton.titleLabel?.font = Font(.medium, size: .size2).font

  		backButton.addTarget(self, action: NSSelectorFromString("backButtonPressed"), for: .touchUpInside)

		saveButton.setTitle("Saglabāt".localized(), for: .normal)

  		saveButton.addTarget(self, action: NSSelectorFromString("saveButtonPressed"), for: .touchUpInside)

		tableView.delegate = self
    	tableView.dataSource = self

//		tableView.contentInset = UIEdgeInsets(top: 16, left: 0, bottom: 12, right: 0)
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
			cell.iconImageView.image = UIImage.init(named: aData.iconName)
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
		if let cell = tableView.cellForRow(at: indexPath) as? AreaEditPageCell {

			if aData.functionalityType == .cellFunctionalityTypeName {
				let cell = self.tableView.cellForRow(at: indexPath) as! AreaEditPageCell
				cell.activateTextField()
			} else if aData.functionalityType == .cellFunctionalityTypeCompany {
				self.controller?.toggleCompanyNamed(name: aData.name, state: !aData.toggleOrCheckmarkIsOn)
				cell.setAccessoryIconType(type: aData.accessoryType, toggleOrCheckmarkIsOn: !aData.toggleOrCheckmarkIsOn)
			}
		}
	}

  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		adjustVisibilityOfShadowLines()
	}

  	// MARK: Functions

	private func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, tableView.contentOffset.y-2))/50.0
		tableViewTopShadow.alpha = alfa
		let value = tableView.contentOffset.y + tableView.frame.size.height - tableView.contentInset.bottom - tableView.contentInset.top
		let alfa2 = min(50, max(0, tableView.contentSize.height-value+6))/50.0
		tableViewBottomShadow.alpha = alfa2
	}

  	@objc private func backButtonPressed() {
  		controller?.backButtonPressed()
  		resignTextField()
  	}

	@objc private func saveButtonPressed() {
  		controller?.saveButtonPressed()
  		resignTextField()
  	}

	private func updateTableViewOffset() {

		let calculatedOffset = (ScenesManager.shared.window!.rootViewController!.view.frame.size.height - tableView.frame.maxY - ScenesManager.shared.window!.safeAreaInsets.top - frontView.frame.minY)

		tableView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: keyboardHeight - calculatedOffset + 12 - 36, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - calculatedOffset, right: 0)
	}

	private func resignTextField() {
		self.tableView.layoutSubviews()
		self.tableView.layoutIfNeeded()
		self.tableView.setContentOffset(.zero, animated: true)
	}

	// MARK: AreaSetUpPage2LayoutViewDataLogic

	func updateData(data: [[AreaSetUpPage.AreaEditPage.ViewModel.DisplayedCell]], name: String) {
		if self.data.isEmpty {
			self.data = data
			tableView.reloadData()
  		} else {
			self.data = data
  		}

  		descriptionCityLabel.text = name
	}

	func updateFrontFrame(to frame: CGRect) {

		keyboardHeight = 0;

		frontViewTopConstraint.constant = frame.origin.y
		frontViewLeftConstraint.constant = frame.origin.x
		frontViewWidthConstraint.constant = frame.size.width
		frontViewHeightConstraint.constant = frame.size.height

		self.tableView.layoutSubviews()
		self.tableView.layoutIfNeeded()
		tableView.reloadData()

		self.tableView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: -36, right: 0)
		self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
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

		descriptionCityLabel.text = cell.titleTextField.text!
		controller?.selectedCityWithName(descriptionCityLabel.text ?? "Jauna vieta")
	}

	func switchWasPressedOnTableViewCell(cell: AreaEditPageCell, withState state: Bool) {

		let indexPath = self.tableView.indexPath(for: cell)!
		let aData = self.data[indexPath.section][indexPath.row]

		if aData.functionalityType == .cellFunctionalityTypeCheapestOnly {
			controller?.userToggledCheapestPrice(to: state)
		}
//		} else if aData.functionalityType == .cellFunctionalityTypePushNotif {
//			controller?.userJustToggledPushNotifSwitch(withState: state)
//		}
	}


	// MARK: Keyboard

	@objc private func keyboardWillShow(notification: NSNotification) {
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardRectangle = keyboardFrame.cgRectValue
			keyboardHeight = keyboardRectangle.height

			updateTableViewOffset()
		}

//        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
//
//			UIView.animate(withDuration: 0.35, animations: {
//				self.tableView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: keyboardSize.height + -36 + -self.superview!.safeAreaInsets.bottom, right: 0)
//				self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + -self.superview!.safeAreaInsets.bottom, right: 0)
//			});
//        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
    	UIView.animate(withDuration: 0.35, animations: {
    		self.tableView.contentInset = UIEdgeInsets(top: -4, left: 0, bottom: -36, right: 0)
				self.tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
		});
    }

//	// MARK: keyboardWillShowNotification
//
//	@objc func keyboardWillShow(_ notification: Notification) {
//		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
//			let keyboardRectangle = keyboardFrame.cgRectValue
//			keyboardHeight = keyboardRectangle.height
//
//			updateTableViewOffset()
//		}
//	}
}
