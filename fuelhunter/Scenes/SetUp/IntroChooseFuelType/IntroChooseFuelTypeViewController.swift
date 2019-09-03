//
//  IntroChooseFuelTypeViewController.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol IntroChooseFuelTypeDisplayLogic: class {
  	func displayListWithData(viewModel: IntroChooseFuelType.FuelCells.ViewModel)
}

class IntroChooseFuelTypeViewController: UIViewController, IntroChooseFuelTypeDisplayLogic, IntroChooseFuelTypeLayoutViewLogic {

  	var interactor: IntroChooseFuelTypeBusinessLogic?
  	var router: (NSObjectProtocol & IntroChooseFuelTypeRoutingLogic & IntroChooseFuelTypeDataPassing)?
	var layoutView: IntroChooseFuelTypeLayoutView!

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
    	self.view.backgroundColor = .white
		setUpView()
    	getData()
  	}

	// MARK: Set up

	private func setup() {
		let viewController = self
		let interactor = IntroChooseFuelTypeInteractor()
		let presenter = IntroChooseFuelTypePresenter()
		let router = IntroChooseFuelTypeRouter()
		viewController.interactor = interactor
		viewController.router = router
		interactor.presenter = presenter
		presenter.viewController = viewController
		router.viewController = viewController
		router.dataStore = interactor
  	}

	func setUpView() {
		layoutView = IntroChooseFuelTypeLayoutView.init(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 100))
		self.view.addSubview(layoutView)
		layoutView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        layoutView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor).isActive = true
        layoutView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor).isActive = true
        layoutView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
		layoutView.controller = self
	}

  	// MARK: Functions

  	func getData() {
    	let request = IntroChooseFuelType.FuelCells.Request()
    	interactor?.getFuelTypesListData(request: request)
  	}

  	func displayListWithData(viewModel: IntroChooseFuelType.FuelCells.ViewModel) {
    	layoutView.updateData(data: viewModel.displayedFuelCellItems)
    	layoutView.setNextButtonAsEnabled(viewModel.nextButtonIsEnabled)
  	}

  	// MARK: IntroChooseFuelTypeLayoutViewLogic

	func switchWasPressedFor(fuelType: FuelType, withState state: Bool) {
		let request = IntroChooseFuelType.SwitchToggled.Request.init(fuelType: fuelType, state: state)
		interactor?.userToggledFuelType(request: request)
	}
	
  	func nextButtonWasPressed() {
  		ScenesManager.shared.advanceAppSceneState()
  	}
}