//
//  SettingsWorker.swift
//  fuelhunter
//
//  Created by Guntis on 27/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

class SettingsWorker {
  	func returnSettingsCellsDataArray(gpsIsEnabled: Bool, notifIsEnabled: Bool, notifCentsValue: Int) -> Settings.SettingsList.Response {
		
		let companyNames = "Neste, Circle K, Kool"
		let fuelTypeNames = "DD Pro, 95, 98"
		let gpsIsEnabledStatus = gpsIsEnabled
		let notifIsEnabledStatus = notifIsEnabled
		
		return Settings.SettingsList.Response.init(companyNames: companyNames, fuelTypeNames: fuelTypeNames, gpsIsEnabledStatus: gpsIsEnabledStatus, pushNotifIsEnabledStatus: notifIsEnabledStatus, notifCentsValue: notifCentsValue)
  	}
}
