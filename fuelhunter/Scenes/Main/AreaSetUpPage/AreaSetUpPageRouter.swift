//
//  AreaSetUpPageRouter.swift
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

protocol AreaSetUpPageReturnUpdateDataLogic: class {
  	func updateData()
}

@objc protocol AreaSetUpPageRoutingLogic {
  	func dismissCurrentViewController()
}

protocol AreaSetUpPageDataPassing {
  	var dataStore: AreaSetUpPageDataStore? { get }
  	var previousViewController: AreaSetUpPageReturnUpdateDataLogic? { get set }
}

class AreaSetUpPageRouter: NSObject, AreaSetUpPageRoutingLogic, AreaSetUpPageDataPassing {
	weak var viewController: AreaSetUpPageViewController?
  	var dataStore: AreaSetUpPageDataStore?
	var previousViewController: AreaSetUpPageReturnUpdateDataLogic?

	// MARK: AreaSetUpPageRoutingLogic

	func dismissCurrentViewController() {
		viewController?.dismiss(animated: true, completion: { [weak self] in self?.previousViewController?.updateData() })
	}
}