//
//  AppSettingsWorker.swift
//  fuelhunter
//
//  Created by Guntis on 14/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

extension Notification.Name {
    static let applicationDidBecomeActiveFromAppSettings = Notification.Name("applicationDidBecomeActiveFromAppSettings")
}

class AppSettingsWorker: NSObject, CLLocationManagerDelegate {

	static let shared = AppSettingsWorker()

	var gpsSwitchHandler: ((LocationToggleResult<Any>) -> Void)?

	let locationManager = CLLocationManager()

	var notificationsAuthorisationStatus: UNAuthorizationStatus = .notDetermined

	private override init() {
		super.init()
		locationManager.delegate = self

    	NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

		refreshCurrentNotificationsStatus {}
	}

	// MARK: Notifications

	@objc func applicationDidBecomeActive() {
		refreshCurrentNotificationsStatus {
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				NotificationCenter.default.post(name: .applicationDidBecomeActiveFromAppSettings, object: nil)
			}
		}
	}

  	// MARK: GPS
  	// Pressed from Intro and from Settings
  	func userPressedButtonToGetGPSAccess(_ handler: @escaping (LocationToggleResult<Any>) -> Void) {

  		if CLLocationManager.authorizationStatus() == .notDetermined
		{
			locationManager.requestWhenInUseAuthorization()
			gpsSwitchHandler = handler;

			return;
		}

		handler(.secondTime)
  	}

	func getGPSIsEnabled() -> Bool {
		if !CLLocationManager.locationServicesEnabled() {
			return false
		}

		if CLLocationManager.authorizationStatus() == .denied
			|| CLLocationManager.authorizationStatus() == .notDetermined {
			return false
		}

		return true
	}
	
	// MARK: Notif

	func refreshCurrentNotificationsStatus(_ handler: @escaping () -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
			self?.notificationsAuthorisationStatus = settings.authorizationStatus
			print(settings)
			handler()
		}
	}

	// Pressed from intro and from settings.
  	func notifSwitchWasPressed(_ handler: @escaping () -> Void) {

		// If status is not determined - request auth.
		// Otherwise, if status is accepted -> turn off |  If declined, then open settings

		if notificationsAuthorisationStatus == .notDetermined {
			UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
				[weak self] granted, error in
				
				// First time, getting access and then set to true if authorized.
				self?.refreshCurrentNotificationsStatus {
					if self?.notificationsAuthorisationStatus == .authorized { self?.setNotifEnabled(enabled: true) }
					DispatchQueue.main.asyncAfter(deadline: .now()) { handler() }
				}
			}
		} else {
			if notificationsAuthorisationStatus == .authorized {
				var notifEnabled = getNotifIsEnabled()
				notifEnabled.toggle()
				setNotifEnabled(enabled: notifEnabled)
			}
			DispatchQueue.main.asyncAfter(deadline: .now()) { handler() }
		}
  	}

	func getNotifIsEnabled() -> Bool {
		if notificationsAuthorisationStatus == .denied { return false }
		return UserDefaults.standard.bool(forKey: "notif_is_enabled")
	}

	func setNotifEnabled(enabled: Bool) {
		UserDefaults.standard.set(enabled, forKey: "notif_is_enabled")
		UserDefaults.standard.synchronize()
	}
	
	// MARK: Stored Notif Cents
	static let minimumNotifCents = 1
	static let maximumNotifCents = 10
	
	func getStoredNotifCentsCount() -> Int {
		return max(AppSettingsWorker.minimumNotifCents, min(AppSettingsWorker.maximumNotifCents,  UserDefaults.standard.integer(forKey: "notif_stored_cents_count")))
	}
	
	func setStoredNotifCentsCount(count: Int) {
		UserDefaults.standard.set(max(AppSettingsWorker.minimumNotifCents, min(AppSettingsWorker.maximumNotifCents, count)), forKey: "notif_stored_cents_count")
		UserDefaults.standard.synchronize()
	}
	
	func getCentsSymbolBasedOnValue(value: Int) -> String {
		switch value {
			case 1: return "➊"
			case 2: return "➋"
			case 3: return "➌"
			case 4: return "➍"
			case 5: return "➎"
			case 6: return "➏"
			case 7: return "➐"
			case 8: return "➑"
			case 9: return "➒"
			case 10: return "➓"
			default: return "0"
		}
	}
	
	// MARK: Stored Companies
	func getCompanyToggleStatus() -> AllCompaniesToogleStatus {
		return UserDefaults.standard.structData(AllCompaniesToogleStatus.self, forKey: "AllCompaniesToogleStatus") ?? AllCompaniesToogleStatus.init()
	}
	
	func setCompanyToggleStatus(allCompanies: AllCompaniesToogleStatus) {
		UserDefaults.standard.setStruct(allCompanies, forKey: "AllCompaniesToogleStatus")
		UserDefaults.standard.synchronize()
	}
	
	// MARK: Stored Fuel Types
	func getFuelTypeToggleStatus() -> AllFuelTypesToogleStatus {
		return UserDefaults.standard.structData(AllFuelTypesToogleStatus.self, forKey: "AllFuelTypesToogleStatus") ?? AllFuelTypesToogleStatus.init()
	}
	
	func setFuelTypeToggleStatus(allFuelTypes: AllFuelTypesToogleStatus) {
		UserDefaults.standard.setStruct(allFuelTypes, forKey: "AllFuelTypesToogleStatus")
		UserDefaults.standard.synchronize()
	}

	// MARK: CLLocationManagerDelegate

	func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

		if let tmpGpsSwitchHandler = gpsSwitchHandler {
			tmpGpsSwitchHandler(.firstTime)
			gpsSwitchHandler = nil
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		if let tmpGpsSwitchHandler = gpsSwitchHandler {
			tmpGpsSwitchHandler(.firstTime)

			gpsSwitchHandler = nil
		}
	}
}
