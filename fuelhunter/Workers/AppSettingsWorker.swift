//
//  AppSettingsWorker.swift
//  fuelhunter
//
//  Created by Guntis on 14/07/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AppSettingsWorker {
  	
  	// MARK: GPS
  	func gpsSwitchWasPressed(_ handler: @escaping (SettingsToggleResult<Bool>) -> Void) {
  		var gpsIsEnabledStatus = self.getGPSIsEnabled()
  		gpsIsEnabledStatus.toggle()
  		setGPSEnabled(enabled: gpsIsEnabledStatus)
		handler(.success(gpsIsEnabledStatus))
//		handler(.failure("Bool is bad"))
  	}

	func getGPSIsEnabled() -> Bool {
		return  UserDefaults.standard.bool(forKey: "gps_is_enabled")
	}
	
	func setGPSEnabled(enabled: Bool) {
		UserDefaults.standard.set(enabled, forKey: "gps_is_enabled")
		UserDefaults.standard.synchronize()
	}
	
	// MARK: Notif
  	func notifSwitchWasPressed(_ handler: @escaping (SettingsToggleResult<Bool>) -> Void) {
  		var notifIsEnabledStatus = self.getNotifIsEnabled()
  		
  		if notifIsEnabledStatus == false {
  			handler(.needsSetUp)
  		} else {
			notifIsEnabledStatus.toggle()
			setNotifEnabled(enabled: notifIsEnabledStatus)
			handler(.success(notifIsEnabledStatus))
//			handler(.failure("Bool is bad"))
		}
  	}

	func getNotifIsEnabled() -> Bool {
		return  UserDefaults.standard.bool(forKey: "notif_is_enabled")
	}
	
	func setNotifEnabled(enabled: Bool) {
		UserDefaults.standard.set(enabled, forKey: "notif_is_enabled")
		UserDefaults.standard.synchronize()
	}
	
	// MARK: Stored Notif Cents
	static let minimumNotifCents = 1
	static let maximumNotifCents = 10
	
	func getStoredNotifCentsCount() -> Int {
		return  max(AppSettingsWorker.minimumNotifCents, min(AppSettingsWorker.maximumNotifCents,  UserDefaults.standard.integer(forKey: "notif_stored_cents_count")))
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
}
