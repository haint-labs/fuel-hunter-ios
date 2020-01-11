//
//  AppDelegate.swift
//  fuelhunter
//
//  Created by Guntis on 29/05/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		//ScenesManager.shared.resetState() // For debug, to start over.
		window?.backgroundColor = .white		
		ScenesManager.shared.window = window
		ScenesManager.shared.setRootViewController(animated: false)

		// To initiate it.
		_ = AppSettingsWorker.shared

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		Font.recalculateFontIncreaseSize()
		DataDownloader.shared.downloadPrices()
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}
	
	// MARK: Token
	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		AppSettingsWorker.shared.setPushNotifToken(deviceTokenString)
		print(deviceTokenString)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
	    print("i am not available in simulator \(error)")
	}
}
