//
//  PushNotifChooseCityLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol PushNotifChooseCityLayoutViewLogic: class {
	func backButtonPressed()
	func selectedCityWithName(_ name: String)
}

protocol PushNotifChooseCityLayoutViewDataLogic: class {
	func updateData(data: PushNotifSetup.SetUp.ViewModel)
	func updateFrontFrame(to frame: CGRect)
}

class PushNotifChooseCityLayoutView: UIView, PushNotifChooseCityLayoutViewDataLogic, SearchTableViewHeaderViewLogic, UITableViewDataSource, UITableViewDelegate {

	weak var controller: PushNotifChooseCityLayoutViewLogic?

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var frontView: UIView!
	@IBOutlet var descriptionCityLabel: UILabel!
	@IBOutlet var backButton: UIButton!
	@IBOutlet var tableViewNoDataView: TableViewNoDataView!
	@IBOutlet var tableView: UITableView!
	@IBOutlet var backgroundDismissButton: UIButton!

	var textField: UITextField?
	var headerView: SearchTableViewHeaderView?

	var frontViewTopConstraint: NSLayoutConstraint!
	var frontViewLeftConstraint: NSLayoutConstraint!
	var frontViewWidthConstraint: NSLayoutConstraint!
	var frontViewHeightConstraint: NSLayoutConstraint!

	var descriptionRightConstraint: NSLayoutConstraint!

	var tableViewBottomConstraint: NSLayoutConstraint!
	var tableViewRightConstraint: NSLayoutConstraint!

	var tableViewNoDataViewRightConstraint: NSLayoutConstraint!

	var sortedCities: [CityAndDistance]!
	var filteredSortedCities: [CityAndDistance]!

	var keyboardHeight: CGFloat = 0
	var shouldRiseKeyboard: Bool = false
	var shouldListShowDistance: Bool = true

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
		Bundle.main.loadNibNamed("PushNotifChooseCityLayoutView", owner: self, options: nil)
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
		tableViewNoDataView.translatesAutoresizingMaskIntoConstraints = false
		backgroundDismissButton.translatesAutoresizingMaskIntoConstraints = false

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
		tableViewRightConstraint = tableView.rightAnchor.constraint(equalTo: frontView.rightAnchor)
		tableViewBottomConstraint = tableView.bottomAnchor.constraint(equalTo: frontView.bottomAnchor, constant: 0)

		tableViewNoDataView.leftAnchor.constraint(equalTo: frontView.leftAnchor, constant: 16).isActive = true
		tableViewNoDataViewRightConstraint = tableViewNoDataView.rightAnchor.constraint(equalTo: frontView.rightAnchor, constant: -16)
		tableViewNoDataView.topAnchor.constraint(equalTo: tableView.topAnchor, constant: 80).isActive = true

		descriptionRightConstraint.isActive = true

		tableViewRightConstraint.isActive = true
		tableViewBottomConstraint.isActive = true

		tableViewNoDataViewRightConstraint.isActive = true

  		frontView.backgroundColor = .white
  		frontView.layer.cornerRadius = 10
  		frontView.layer.shadowColor = UIColor(red: 66/255.0, green: 93/255.0, blue: 146/255.0, alpha: 0.44).cgColor
  		frontView.layer.shadowOpacity = 1
  		frontView.layer.shadowRadius = 8

  		descriptionCityLabel.font = Font(.normal, size: .size2).font

  		backButton.addTarget(self, action: NSSelectorFromString("backButtonPressed"), for: .touchUpInside)

		tableView.backgroundColor = .clear
  		tableView.delegate = self
    	tableView.dataSource = self
    	tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 12, right: 0)
		tableView.scrollIndicatorInsets.right = 2
    	let nibCell = UINib(nibName: "ChooseCityCell", bundle: nil)
    	let nibHeader = UINib(nibName: "SearchTableViewHeaderView", bundle: nil)
    	tableView.register(nibCell, forCellReuseIdentifier: "cell")
		self.tableView.register(nibHeader, forHeaderFooterViewReuseIdentifier: "header")

		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)

		if AppSettingsWorker.shared.getGPSIsEnabled() == false {
			shouldListShowDistance = false
		}

		tableViewNoDataView.setSmallerFont()
		tableViewNoDataView.alpha = 0
		adjustNoDataLabelText()
  	}

	// MARK: Table view

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filteredSortedCities.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

		if let cell = tableView.dequeueReusableCell(
		   withIdentifier: "cell",
		   for: indexPath
		) as? ChooseCityCell {
			let city = filteredSortedCities[indexPath.row]
			cell.selectionStyle = .none
			cell.backgroundColor = .clear

			if let textField = textField, let text = textField.text {
				cell.setText(text: city.name!.localized(), with: (text.isEmpty ? nil : text) )
			} else {
				cell.setText(text: city.name!.localized(), with: nil)
			}

			cell.setDistance(value: city.distanceInKm, visible: shouldListShowDistance)

			if indexPath.row == filteredSortedCities.count-1 {
				cell.setAsCellType(cellType: .bottom)
			} else {
				cell.setAsCellType(cellType: .middle)
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

	func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! SearchTableViewHeaderView
		header.controller = self
		textField = header.textField
		headerView = header
		if shouldRiseKeyboard {
			headerView?.activateTextField()
		}
        return header
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		controller?.selectedCityWithName(filteredSortedCities[indexPath.row].name)
		resignTextField()
	}

  	// MARK: Functions

  	@objc private func backButtonPressed() {
  		controller?.backButtonPressed()
  		resignTextField()
  	}

	private func updateTableViewOffset() {
		let calculatedOffset = (self.frame.height - frontView.frame.maxY)
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - calculatedOffset + 12, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - calculatedOffset, right: 0)
	}

	private func resignTextField() {
		shouldRiseKeyboard = false
		headerView?.deactivateTextField()

		self.tableView.layoutSubviews()
		self.tableView.layoutIfNeeded()
		self.tableView.setContentOffset(.zero, animated: true)
	}

	private func adjustNoDataLabelText() {
		self.tableViewNoDataView.set(title: "intro_notifs_no_data_found_when_filtered".localized(), loadingEnabled: false)
	}

	// MARK: PushNotifChooseCityLayoutViewDataLogic

	func updateData(data: PushNotifSetup.SetUp.ViewModel) {
		sortedCities = data.displayedItem.sortedCities
		filteredSortedCities = sortedCities
	}

	func updateFrontFrame(to frame: CGRect) {
		shouldRiseKeyboard = true
		descriptionCityLabel.text = "settings_choose_city_title".localized()

		frontViewTopConstraint.constant = frame.origin.y
		frontViewLeftConstraint.constant = frame.origin.x
		frontViewWidthConstraint.constant = frame.size.width
		frontViewHeightConstraint.constant = frame.size.height

		filteredSortedCities = sortedCities
		
		self.tableView.layoutSubviews()
		self.tableView.layoutIfNeeded()
		tableView.reloadData()

		let calculatedOffset = (self.frame.height - frame.size.height - frame.origin.y)
		tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - calculatedOffset + 12, right: 0)
		tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - calculatedOffset, right: 0)
	}

	// MARK: SearchTableViewHeaderViewLogic

	func textFieldValueWasChanged(textField: UITextField) {
		if let text = textField.text, text.isEmpty == false {
			filteredSortedCities = sortedCities.filter({$0.name.localized().range(of: text, options: [.caseInsensitive, .diacriticInsensitive]) != nil})
		} else {
			filteredSortedCities = sortedCities
		}

		if filteredSortedCities.isEmpty {
			self.tableViewNoDataView.alpha = 1
			self.tableView.isScrollEnabled = false
		} else {
			self.tableViewNoDataView.alpha = 0
			self.tableView.isScrollEnabled = true
		}

		// simple reloadData, but with a tinsy fade animation. We can't reload section with animation, because textfield in section header.
		UIView.transition(with: tableView, duration: 0.1, options: .transitionCrossDissolve, animations: { self.tableView.reloadData() })
	}

	// MARK: keyboardWillShowNotification

	@objc func keyboardWillShow(_ notification: Notification) {
		if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
			let keyboardRectangle = keyboardFrame.cgRectValue
			keyboardHeight = keyboardRectangle.height

			updateTableViewOffset()
		}
	}
}
