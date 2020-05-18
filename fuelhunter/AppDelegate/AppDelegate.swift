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

		application.registerForRemoteNotifications()

		// To initiate it.
		_ = AppSettingsWorker.shared

//		ScenesManager.shared.resetState() // For debug, to start over.
		window?.backgroundColor = .white
		ScenesManager.shared.window = window
		ScenesManager.shared.setRootViewController(animated: false)


		_ = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(downloaderTestTimer), userInfo: nil, repeats: true)


//		let group = PlatformSupport.makeEventLoopGroup(loopCount: 1)
//		let channel = ClientConnection
//			.insecure(group: group)
//			.connect(host: "162.243.16.251", port: 50051)
//		let client = SnapshotServiceClient(channel: channel)
//		let query = SnapshotQuery.with { _ in }
//
//		do {
//			let response = try client.getSnapshots(query)
//				.response
//				.wait()
//			response.snapshots.forEach { print("printing snapshots \($0)") }
//			print(response.snapshots.count)
//		} catch {
//			print("caught: \(error)")
////			fatalError()
//		}


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
		DataDownloader.shared.activateProcess()
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
		let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
		AppSettingsWorker.shared.setPushNotifToken(deviceTokenString)
		print(deviceTokenString)
	}
	
	func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
	    print("i am not available in simulator \(error)")
	}
}
