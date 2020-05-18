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
import FirebaseMessaging
import UserNotifications
import FirebaseInstanceID
import SDWebImage

extension Notification.Name {
    static let applicationDidBecomeActiveFromAppSettings = Notification.Name("applicationDidBecomeActiveFromAppSettings")

    static let languageWasChanged = Notification.Name("languageWasChanged")

    static let settingsUpdated = Notification.Name("settingsUpdated")

    static let fontSizeWasChanged = Notification.Name("fontSizeWasChanged")

    static let dataDownloaderStateChange = Notification.Name("dataDownloaderStateChange")

    static let checkForCompanyChanges = Notification.Name("checkForCompanyChanges")

    static let cityNameUpdated = Notification.Name("cityNameUpdated")
}

protocol AppSettingsWorkerLogic {
	func setUpGlobalFontColorAndSize()
	func getCurrentLanguage() -> AppSettingsWorker.Language
	func setCurrentLanguage(_ language: AppSettingsWorker.Language)
	func userPressedButtonToGetGPSAccess(_ handler: @escaping (LocationToggleResult<Any>) -> Void)
	func getGPSIsEnabled() -> Bool
	func getPushNotifToken() -> String
	func setPushNotifToken(_ token: String)
	func notifSwitchWasPressed(_ handler: @escaping () -> Void)
	func getNotifIsEnabled() -> Bool
	func setNotifEnabled(enabled: Bool)
	func getStoredLastGPSDetectedCityName() -> String
	func setStoredLastGPSDetectedCityName(name: String)
	func getStoredNotifCityName() -> String
	func setStoredNotifCity(name: String)
	func getStoredNotifCentsCount() -> Int
	func setStoredNotifCentsCount(count: Int)
	func getCentsSymbolBasedOnValue(value: Int) -> String
	func getFuelTypeToggleStatus() -> AllFuelTypesToogleStatus
	func setFuelTypeToggleStatus(allFuelTypes: AllFuelTypesToogleStatus)
}

class AppSettingsWorker: NSObject, AppSettingsWorkerLogic, CLLocationManagerDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {

	enum Language: String {
		case latvian = "lv"
		case russian = "ru"
		case english = "en"
		case latgalian = "lv-LV"
	}

	static let shared = AppSettingsWorker()

	private let locationManager = CLLocationManager()

	var gpsSwitchHandler: ((LocationToggleResult<Any>) -> Void)?
	var userLocation: CLLocation?
	var notificationsAuthorisationStatus: UNAuthorizationStatus = .notDetermined
	var languageBundle: Bundle!

	//--- Used to get specific translation.
	var ruLanguageBundle = Bundle(path: Bundle.main.path(forResource: "ru", ofType: "lproj")!)!
	var lvLanguageBundle = Bundle(path: Bundle.main.path(forResource: "lv", ofType: "lproj")!)!
	var enLanguageBundle = Bundle(path: Bundle.main.path(forResource: "en", ofType: "lproj")!)!
	var lgLanguageBundle = Bundle(path: Bundle.main.path(forResource: "lv-LV", ofType: "lproj")!)!
	//===

	private override init() {
		super.init()

		SDImageCache.shared.config.maxDiskAge = 60*60*24*365//-1
//		SDImageCache.shared.clearDisk()
		locationManager.delegate = self
		locationManager.desiredAccuracy = kCLLocationAccuracyBest
		locationManager.distanceFilter = 200
		locationManager.startUpdatingLocation()
    	NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
		
		refreshCurrentNotificationsStatus {}

		Font.recalculateFontIncreaseSize()
		
		self.setUpBundle()

		setUpGlobalFontColorAndSize()

		UNUserNotificationCenter.current().delegate = self
		Messaging.messaging().delegate = self
	}

	func setUpGlobalFontColorAndSize() {
		UINavigationBar.appearance().tintColor = UIColor(named: "TitleColor")!
		UINavigationBar.appearance().titleTextAttributes =
			[NSAttributedString.Key.foregroundColor: UIColor(named: "TitleColor")!,
			NSAttributedString.Key.font: Font(.normal, size: .size1).font]
	}

	// MARK: Notifications

	@objc private func applicationDidBecomeActive() {
		refreshCurrentNotificationsStatus {
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				NotificationCenter.default.post(name: .applicationDidBecomeActiveFromAppSettings, object: nil)

				let cityName = CityWorker.getClosestCityName()
				self.setStoredLastGPSDetectedCityName(name: cityName)
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

	private func setUpBundle() {
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

	// MARK: Push notif token

	func getPushNotifToken() -> String {
		return UserDefaults.standard.string(forKey: "push_notif_token") ?? ""
	}

	func setPushNotifToken(_ token: String) {
		UserDefaults.standard.set(token, forKey: "push_notif_token")
		UserDefaults.standard.synchronize()
	}

	// MARK: Notif

	private func refreshCurrentNotificationsStatus(_ handler: @escaping () -> Void) {
		UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
			self?.notificationsAuthorisationStatus = settings.authorizationStatus
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

				if notifEnabled == false {
					let cityName = CityWorker.getClosestCityName()
					self.setStoredLastGPSDetectedCityName(name: cityName)
					self.setStoredNotifCity(name: cityName)
				}
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

	// MARK: Stored Last GPS Detected City Name
	
	func getStoredLastGPSDetectedCityName() -> String {
		return UserDefaults.standard.string(forKey: "gps_last_stored_city_name") ?? CityWorker.rigaCity.name
	}
	
	func setStoredLastGPSDetectedCityName(name: String) {
		let lastGPS = getStoredLastGPSDetectedCityName()
		UserDefaults.standard.set(name, forKey: "gps_last_stored_city_name")
		UserDefaults.standard.synchronize()

		// If the name is changed.. This city name will be used for list.
		if lastGPS != name {
			PricesDownloader.removeAllPricesAndCallDownloader()
			NotificationCenter.default.post(name: .cityNameUpdated, object: nil)
		}
	}

	// MARK: Stored Notif City Name
	
	func getStoredNotifCityName() -> String {
		return UserDefaults.standard.string(forKey: "notif_stored_city_name") ?? CityWorker.rigaCity.name
	}
	
	func setStoredNotifCity(name: String) {
		UserDefaults.standard.set(name, forKey: "notif_stored_city_name")
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
	
	// MARK: Stored Fuel Types
	
	func getFuelTypeToggleStatus() -> AllFuelTypesToogleStatus {
		return UserDefaults.standard.structData(AllFuelTypesToogleStatus.self, forKey: "AllFuelTypesToogleStatus") ?? AllFuelTypesToogleStatus()
	}

	func setFuelTypeToggleStatus(allFuelTypes: AllFuelTypesToogleStatus) {
		UserDefaults.standard.setStruct(allFuelTypes, forKey: "AllFuelTypesToogleStatus")
		UserDefaults.standard.synchronize()
		NotificationCenter.default.post(name: .settingsUpdated, object: nil)
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

		if let userLocation = userLocation, let lastLocation = locations.last {
			let distanceInMeters = userLocation.distance(from: lastLocation)

			print("distanceInMeters \(distanceInMeters)")

			if distanceInMeters < 50 {
				return
			}
		}

		print("Set up user location and reset previous stored distances")
		
		userLocation = locations.last

		let currentDetected = CityWorker.getClosestCityName()
		setStoredLastGPSDetectedCityName(name: currentDetected)

		AddressesWorker.resetAllAddressesDistances()
	}

	// MARK: UNUserNotificationCenterDelegate

	func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {

	}

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    }

//  @available(iOS 12.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) {

    }

    // MARK: MessagingDelegate

	func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
		let dataDict:[String: String] = ["token": fcmToken]
		print("dataDict \(dataDict)")

		InstanceID.instanceID().instanceID { (result, error) in
		  if let error = error {
			print("Error fetching remote instance ID: \(error)")
		  } else if let result = result {
			print("Remote instance ID token: \(result.token)")
//			self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
		  }
		}


		NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
	}

//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//		print("remoteMessage \(remoteMessage)")
//    }
}
