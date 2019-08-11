//
//  ScenesManager.swift
//  fuelhunter
//
//  Created by Guntis on 16/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

enum AppSceneState: Int {
	case introPageFirstView = 0
	case introPageChooseCompany = 1
	case introPageChooseFuelType = 2
	case introPageGPSAccessAsking = 3
	case introPageNotifAccessAsking = 4
	case mainList = 5
}

class ScenesManager: NSObject {

	static let shared = ScenesManager()

	weak var window: UIWindow?

	func setRootViewController(animated: Bool) {
		var destinationVC: UIViewController?

  		let sceneState = ScenesManager.shared.getAppSceneState()

  		switch sceneState {
			case .introPageFirstView:
				destinationVC = IntroPageViewController()
			case .introPageChooseCompany:
				destinationVC = IntroChooseCompanyViewController()
			case .introPageChooseFuelType:
				destinationVC = IntroChooseFuelTypeViewController()
			case .introPageGPSAccessAsking:
				destinationVC = IntroGPSSetUpViewController()
			case .introPageNotifAccessAsking:
				destinationVC = IntroNotifSetUpViewController()
			default:
				destinationVC = MainFuelListViewController()
		}

  		let rootVc = ScenesManager.shared.window?.rootViewController as! UINavigationController  		
  		rootVc.setViewControllers([destinationVC!], animated: animated)

		switch sceneState {
			case .mainList:
				rootVc.setNavigationBarHidden(false, animated: animated)
			default:
				rootVc.setNavigationBarHidden(true, animated: animated)
		}
	}

	func advanceAppSceneState() {
		var sceneState = ScenesManager.shared.getAppSceneState()

		if sceneState != .mainList {
			sceneState = AppSceneState(rawValue: sceneState.rawValue+1)!
			ScenesManager.storeAppSceneState(state: sceneState)
			
			ScenesManager.shared.setRootViewController(animated: true)
		} else {
			print("This should not happen. Scene is already max")
		}
	}

	// For debug //
	func resetState() {
		ScenesManager.storeAppSceneState(state: .introPageFirstView)
	}

	private func getAppSceneState() -> AppSceneState {
		return AppSceneState(rawValue: UserDefaults.standard.integer(forKey: "app_scene_state")) ?? AppSceneState.introPageFirstView
	}

	private class func storeAppSceneState(state: AppSceneState) {
		UserDefaults.standard.set(state.rawValue, forKey: "app_scene_state")
		UserDefaults.standard.synchronize()
	}
}



