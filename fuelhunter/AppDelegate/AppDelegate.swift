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
import FirebaseCrashlytics

import CoreData
import FHClient
import GRPC
import NIO

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?
	
	func application(_ application: UIApplication, didFinishLaunchingWithOptions
		launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.

		FirebaseApp.configure()
		Crashlytics.crashlytics()

		application.registerForRemoteNotifications()

		// To initiate it.
		_ = AppSettingsWorker.shared

//		ScenesManager.shared.resetState() // For debug, to start over.
		window?.backgroundColor = .white
		ScenesManager.shared.window = window
		ScenesManager.shared.setRootViewController(animated: false)


		AddressesWorker.readAllAddressesFromFile()

		_ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(downloaderTestTimer), userInfo: nil, repeats: true)

//		PricesDownloader.resetLastDownloadTime()

		if PricesDownloader.shouldInitiateDownloadWhenPossible() {
			PricesDownloader.removeAllPricesAndCallDownloader()
		}

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

		if PricesDownloader.shouldInitiateDownloadWhenPossible() {
			PricesDownloader.removeAllPricesAndCallDownloader()
		}

		DataDownloader.shared.activateProcess()

		AddressesWorker.debugStuff()
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}

	// MARK: Functions

	@objc private func downloaderTestTimer() {
		print("downloaderTestTimer fired!")

//		CompaniesDownloader.resetLastDownloadTime()
//		PricesDownloader.resetLastDownloadTime()

		DataDownloader.shared.activateProcess()
	}

	// MARK: Token

	func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
//		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
//		AppSettingsWorker.shared.setPushNotifToken(deviceTokenString)
//		print(deviceTokenString)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
	    print("i am not available in simulator \(error)")
	    Crashlytics.crashlytics().record(error: error)
	}
}
