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
		Utility.doit()

		
		UINavigationBar.appearance().tintColor = UIColor.init(named: "TitleColor")!

		UINavigationBar.appearance().titleTextAttributes =
			[NSAttributedString.Key.foregroundColor: UIColor.init(named: "TitleColor")!,
			NSAttributedString.Key.font: Font.init(.normal, size: .size1).font]

		return true
	}

	func applicationWillResignActive(_ application: UIApplication) {
	}

	func applicationDidEnterBackground(_ application: UIApplication) {
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
	}

	func applicationWillTerminate(_ application: UIApplication) {
	}
}
