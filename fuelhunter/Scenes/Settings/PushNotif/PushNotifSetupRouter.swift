//
//  PushNotifSetupRouter.swift
//  fuelhunter
//
//  Created by Guntis on 10/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol PushNotifReturnUpdateDataLogic: class {
  	func updateData()
}

@objc protocol PushNotifSetupRoutingLogic {
  	func dismissCurrentViewController()
  	func chooseCityButtonPressed()
}

protocol PushNotifSetupDataPassing {
  	var dataStore: PushNotifSetupDataStore? { get }
  	var previousViewController: PushNotifReturnUpdateDataLogic? { get set }
}

class PushNotifSetupRouter: NSObject, PushNotifSetupRoutingLogic, PushNotifSetupDataPassing {
	weak var viewController: PushNotifSetupViewController?
  	var dataStore: PushNotifSetupDataStore?
	var previousViewController: PushNotifReturnUpdateDataLogic?

	// MARK: Routing

	func dismissCurrentViewController() {
		viewController?.dismiss(animated: true, completion: { [weak self] in self?.previousViewController?.updateData() })
	}

	func chooseCityButtonPressed() {
//		let destination = PushNotifChooseCityViewController()
//		destination.modalTransitionStyle = .flipHorizontal
//		viewController?.present(destination, animated: true, completion: nil)
	}
}