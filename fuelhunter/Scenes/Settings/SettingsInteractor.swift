//
//  SettingsInteractor.swift
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

protocol SettingsBusinessLogic {
  	func getSettingsCellsData(request: Settings.SettingsList.Request)
}

protocol SettingsDataStore {
  	//var name: String { get set }
}

class SettingsInteractor: SettingsBusinessLogic, SettingsDataStore {
  	var presenter: SettingsPresentationLogic?
  	var worker = SettingsWorker()
  	//var name: String = ""

  	// MARK: Do something

  	func getSettingsCellsData(request: Settings.SettingsList.Request) {
    	let response = worker.returnSettingsCellsDataArray()

    	presenter?.presentSettingsListWithData(response: response)
  	}
}
