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
import CoreTelephony

extension Notification.Name {
    static let applicationDidBecomeActiveFromAppSettings = Notification.Name("applicationDidBecomeActiveFromAppSettings")

    static let languageWasChanged = Notification.Name("languageWasChanged")

    static let fontSizeWasChanged = Notification.Name("fontSizeWasChanged")
}

class AppSettingsWorker: NSObject, CLLocationManagerDelegate {

	enum Language: String {
		case latvian = "lv"
		case russian = "ru"
		case english = "en"
	}

	static let shared = AppSettingsWorker()

	var gpsSwitchHandler: ((LocationToggleResult<Any>) -> Void)?

	let locationManager = CLLocationManager()

	var notificationsAuthorisationStatus: UNAuthorizationStatus = .notDetermined

	var userLocation: CLLocation?

	var languageBundle: Bundle!

	private override init() {
		super.init()
		locationManager.delegate = self
		locationManager.desiredAccuracy = 100
		locationManager.startUpdatingLocation()
    	NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)

		refreshCurrentNotificationsStatus {}

		Font.recalculateFontIncreaseSize()
		
		self.setUpBundle()

		setUpGlobalFontColorAndSize()
	}

	func setUpGlobalFontColorAndSize() {
		UINavigationBar.appearance().tintColor = UIColor(named: "TitleColor")!
		UINavigationBar.appearance().titleTextAttributes =
			[NSAttributedString.Key.foregroundColor: UIColor(named: "TitleColor")!,
			NSAttributedString.Key.font: Font(.normal, size: .size1).font]
	}

	// MARK: Notifications

	@objc func applicationDidBecomeActive() {
		refreshCurrentNotificationsStatus {
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				NotificationCenter.default.post(name: .applicationDidBecomeActiveFromAppSettings, object: nil)
			}
		}
	}

	// MARK: Language

	func getCurrentLanguage() -> Language {
		// 1. Use previously selected/detected language.
		if let language = UserDefaults.standard.string(forKey: "Language") {
			return Language(rawValue: language)!
		}

		// 2. Check prefered phone language. If it is russian, then select russian
		let preferredLanguage = Locale.preferredLanguages[0] as String
		if preferredLanguage.lowercased().contains("ru") { return Language.russian }

		// 3. Check prefered phone language. If it is latvian, then select latvian
		if preferredLanguage.lowercased().contains("lv") { return Language.latvian }

		// 4. Check sim card country. If it is latvian, then select latvian
		let telephony = CTTelephonyNetworkInfo()
		let carrier = telephony.subscriberCellularProvider
		if let carrier = carrier, carrier.mobileCountryCode == "247" {
			return Language.latvian
		}

		// 5. If all other check fails - go to default, english.
		return Language.english
	}

	func setCurrentLanguage(_ language: Language) {
		UserDefaults.standard.set(language.rawValue, forKey: "Language")
		UserDefaults.standard.synchronize()
		setUpBundle()
		NotificationCenter.default.post(name: .languageWasChanged, object: nil)
	}

	func setUpBundle() {
        if let path = Bundle.main.path(forResource: self.getCurrentLanguage().rawValue, ofType: "lproj"),
            let bundle = Bundle(path: path) {
            languageBundle = bundle
        }
        // Default will work.
        else if let path = Bundle.main.path(forResource: "en", ofType: "lproj"),
            let bundle = Bundle(path: path) {
            languageBundle = bundle
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
			userLocation = nil
			return false
		}

		if CLLocationManager.authorizationStatus() == .denied
			|| CLLocationManager.authorizationStatus() == .notDetermined {
			userLocation = nil
			return false
		}

		return true
	}

	func getUserLocation() -> CLLocation? {
		return userLocation
	}
	// MARK: Notif

	func refreshCurrentNotificationsStatus(_ handler: @escaping () -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
			self?.notificationsAuthorisationStatus = settings.authorizationStatus
//			print(settings)
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
		return UserDefaults.standard.structData(AllCompaniesToogleStatus.self, forKey: "AllCompaniesToogleStatus") ?? AllCompaniesToogleStatus()
	}
	
	func setCompanyToggleStatus(allCompanies: AllCompaniesToogleStatus) {
		UserDefaults.standard.setStruct(allCompanies, forKey: "AllCompaniesToogleStatus")
		UserDefaults.standard.synchronize()
	}
	
	// MARK: Stored Fuel Types
	func getFuelTypeToggleStatus() -> AllFuelTypesToogleStatus {
		return UserDefaults.standard.structData(AllFuelTypesToogleStatus.self, forKey: "AllFuelTypesToogleStatus") ?? AllFuelTypesToogleStatus()
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

		if status == .authorizedWhenInUse {
			locationManager.startUpdatingLocation()
		} else {
			locationManager.stopUpdatingLocation()
		}
	}

	func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
	{
		if let tmpGpsSwitchHandler = gpsSwitchHandler {
			tmpGpsSwitchHandler(.firstTime)

			gpsSwitchHandler = nil
		}
	}

	func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
		userLocation = locations.last
	}
}
