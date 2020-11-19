//
//  MainViewsListViewController.swift
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


protocol MainViewsListDisplayLogic: class {
	func displayData(viewModel: MainViewsList.FetchAreas.ViewModel)
}

class MainViewsListViewController: UIViewController, MainViewsListDisplayLogic, MainViewsListLayoutViewLogic {

	var interactor: MainViewsListBusinessLogic?
	var router: (NSObjectProtocol & MainViewsListRoutingLogic & MainViewsListDataPassing)?
	var layoutView: MainViewsListLayoutView!

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

	deinit {
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.navigationController!.interactivePopGestureRecognizer?.delegate = nil
		self.navigationController!.interactivePopGestureRecognizer?.isEnabled = true

		self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
    	self.navigationController!.navigationBar.shadowImage = UIImage()
		self.navigationController!.navigationBar.isTranslucent = true
    	self.view.backgroundColor = .white
    	self.navigationController!.setNavigationBarHidden(true, animated: false)

		setUpView()
		getData()
	}

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

    	self.navigationController!.setNavigationBarHidden(true, animated: true)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
	}

	//MARK: Set up

	private func setup() {
		let viewController = self
		let interactor = MainViewsListInteractor()
		let presenter = MainViewsListPresenter()
		let router = MainViewsListRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
	}

	private func setUpView() {
		layoutView = MainViewsListLayoutView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
		layoutView.navigationController = self.navigationController
	}

	// MARK: Functions

	private func getData() {
		let request = MainViewsList.FetchAreas.Request()
		interactor?.fetchAreas(request: request)
	}

	// MARK: MainViewsListDisplayLogic

	func displayData(viewModel: MainViewsList.FetchAreas.ViewModel) {
		self.layoutView.setUpPages(areaNames: viewModel.displayedAreas)
	}

	// MARK: MainViewsListLayoutViewLogic

	func settingsButtonPressed() {
		router?.routeToSettings()
	}

	func areasListButtonPressed() {
		router?.routeToAreasList()
	}
}