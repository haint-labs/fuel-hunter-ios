//
//  FuelListViewController.swift
//  fuelhunter
//
//  Created by Guntis on 03/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit


protocol FuelListDisplayLogic: class {
	func displaySomething(viewModel: FuelList.FetchPrices.ViewModel)
}

class FuelListViewController: UIViewController, FuelListDisplayLogic, FuelListLayoutViewLogic, MapReturnUpdateDataLogic, FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol {
	
	var interactor: FuelListBusinessLogic?
	var router: (NSObjectProtocol & FuelListRoutingLogic & FuelListDataPassing)?
	var layoutView: FuelListLayoutView!
	var selectedCell: FuelListCell?
	
	// MARK: Object lifecycle

	override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		setup()
	}

	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		setup()
	}

	// MARK: View lifecycle

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController!.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem.init(image:
			UIImage.init(named: "Settings_icon"), style: .plain, target: router, action:NSSelectorFromString("routeToSettings"))
		self.navigationController!.navigationBar.topItem?.title = "Fuel Hunter"
		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    	self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.isTranslucent = true
    	self.view.backgroundColor = .white
		setUpView()
		getData()
	}

	// Set up

	private func setup() {
		let viewController = self
		let interactor = FuelListInteractor()
		let presenter = FuelListPresenter()
		let router = FuelListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	func setUpView() {
		layoutView = FuelListLayoutView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

	// MARK: Functions

	func getData() {
		let request = FuelList.FetchPrices.Request()
		interactor?.fetchPrices(request: request)
	}

	func displaySomething(viewModel: FuelList.FetchPrices.ViewModel) {
		layoutView.updateData(data: viewModel.displayedPrices)
	}

	// MARK: FuelListLayoutViewLogic

	func savingsButtonPressed() {
		router?.routeToAppSavingsInfo()
	}

	func accuracyButtonPressed() {
		router?.routeToAppAccuracyInfo()
	}

	func pressedOnACell(atYLocation yLocation: CGFloat, forCell cell: FuelListCell, withDataArray dataArray: [FuelList.FetchPrices.ViewModel.DisplayedPrice], dataIndex index: Int, dataSection section: Int) {
		selectedCell = cell
		selectedCell?.isHidden = true
		router?.routeToMapView(atYLocation: yLocation, withDataArray: dataArray, dataIndex: index, dataSection: section)
	}
	
	// MARK: FuelListToMapViewPopTransitionAnimatorFinaliseHelperProtocol
	
	func customTransitionWasFinished() {
		selectedCell?.isHidden = false
	}

	// MARK: MapReturnUpdateDataLogic

	func justSelectedACell(atIndexPath indexPath: IndexPath) -> CGFloat {
		selectedCell?.isHidden = false
		if let cell = layoutView.tableView.cellForRow(at: indexPath) {
			// We found a cell!
			selectedCell = cell as? FuelListCell
			let cellRect = layoutView.tableView.rectForRow(at: indexPath)
			if !layoutView.tableView.bounds.contains(cellRect) {
				// Cell is partly visible. So we scroll to reveal it fully. Just a nicety
				if cellRect.origin.y > layoutView.tableView.bounds.origin.y {
					layoutView.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
				} else {
					layoutView.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
				}
			}
		} else {
			// No cell. So, we scroll to middle, to reveal it.
			layoutView.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
			if let cell = layoutView.tableView.cellForRow(at: indexPath) {
				selectedCell = cell as? FuelListCell
			}
		}
		
		selectedCell?.isHidden = true
		let rect = layoutView.tableView.rectForRow(at: indexPath)
		let rectInScreen = layoutView.tableView.convert(rect, to: self.view)
		return rectInScreen.origin.y
	}
}