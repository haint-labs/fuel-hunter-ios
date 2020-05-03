//
//  AppDelegate.swift
//  fuelhunter
//
//  Created by Guntis on 29/05/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage
import Firebase
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		FirebaseApp.configure()

		application.registerForRemoteNotifications()

//		ScenesManager.shared.resetState() // For debug, to start over.
		window?.backgroundColor = .white
		ScenesManager.shared.window = window
		ScenesManager.shared.setRootViewController(animated: false)

		DataBaseManager.shared.saveContext()
		
		// To initiate it.
		_ = AppSettingsWorker.shared

		_ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)

		return true
	}

	@objc func fireTimer() {
		print("Timer fired!")

//		CompaniesDownloader.resetLastDownloadTime()
//		PricesDownloader.resetLastDownloadTime()
		DataDownloader.shared.activateProcess()
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		Font.recalculateFontIncreaseSize()
		DataDownloader.shared.activateProcess()
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
