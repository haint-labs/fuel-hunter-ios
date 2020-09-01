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
import CoreData
import FirebaseCrashlytics
protocol SettingsBusinessLogic {
  	func getSettingsCellsData(request: Settings.SettingsList.Request)
  	func userPressedOnNotifSwitch()
  	func userPressedOnGpsSwitch()
}

protocol SettingsDataStore {
  	//var name: String { get set }
}

class SettingsInteractor: NSObject, SettingsBusinessLogic, SettingsDataStore, NSFetchedResultsControllerDelegate {
  	var presenter: SettingsPresentationLogic?
	var fetchedResultsController: NSFetchedResultsController<CompanyEntity>!
  	var settingsWorker = SettingsWorker()

	// MARK: SettingsBusinessLogic

  	func getSettingsCellsData(request: Settings.SettingsList.Request) {

		if fetchedResultsController == nil {
			let context = DataBaseManager.shared.mainManagedObjectContext()
			let fetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
			fetchRequest.predicate = NSPredicate(format: "isEnabled == %i && isHidden == %i", true, false)
			let sort = NSSortDescriptor(key: "order", ascending: true)
			fetchRequest.sortDescriptors = [sort]
			fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)

			fetchedResultsController.delegate = self
		}

		var fetchedCompanies: [CompanyEntity]?

		do {
			try fetchedResultsController.performFetch()

			fetchedCompanies = fetchedResultsController.fetchedObjects
		} catch let error {
			// Something went wrong
			Crashlytics.crashlytics().record(error: error)
			print("Something went wrong. \(error)")
		}


		let gpsIsEnabledStatus = AppSettingsWorker.shared.getGPSIsEnabled()
		let notifIsEnabledStatus = AppSettingsWorker.shared.getNotifIsEnabled()
		let notifCentsValue = AppSettingsWorker.shared.getStoredNotifCentsCount()
		let companyNames = settingsWorker.getCompanyNames(fromFetchedCompanies: fetchedCompanies ?? [])
		let fuelTypeNames = AppSettingsWorker.shared.getFuelTypeToggleStatus().description
		let selectedCityName = AppSettingsWorker.shared.getStoredNotifCityName()

		let response = Settings.SettingsList.Response(companyNames: companyNames, fuelTypeNames: fuelTypeNames, gpsIsEnabledStatus: gpsIsEnabledStatus, pushNotifIsEnabledStatus: notifIsEnabledStatus, notifCentsValue: notifCentsValue, notifSelectedCityName: selectedCityName)
		presenter?.presentSettingsListWithData(response: response)
  	}

  	func userPressedOnNotifSwitch() {
  		AppSettingsWorker.shared.notifSwitchWasPressed { [weak self] in
  			// If we have authorised, then we can work with our set Up.
  			if AppSettingsWorker.shared.notificationsAuthorisationStatus == .authorized {
  				// This is already toggled in notifSwitchWasPressed.  So, then we just do set up view
				if AppSettingsWorker.shared.getNotifIsEnabled() == true {
					let storedCentsCount = AppSettingsWorker.shared.getStoredNotifCentsCount()
					let response = Settings.PushNotif.Response(storedNotifCentsCount: storedCentsCount)
					self?.presenter?.showNotifSetUp(response: response)
				} else { // We disabled, so simply reload table view.
					let request = Settings.SettingsList.Request()
					self?.getSettingsCellsData(request: request)
					DataDownloader.shared.removeToken()
				}
			} else {
				// This case it will always return as disabled, and so we only have to open settings and reload table view (to show it turned off if it was on.)
				UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
				let request = Settings.SettingsList.Request()
				self?.getSettingsCellsData(request: request)
			}
		}
  	}

  	func userPressedOnGpsSwitch() {
  		AppSettingsWorker.shared.userPressedButtonToGetGPSAccess { result in
  			switch result {
  				case .firstTime:
					// All good, but reload data.
					let request = Settings.SettingsList.Request()
					self.getSettingsCellsData(request: request)
				case .secondTime:
					UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!, options: [:], completionHandler: nil)
			}
		}
  	}

  	// MARK: NSFetchedResultsControllerDelegate

  	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
  		getSettingsCellsData(request: Settings.SettingsList.Request())
	}
}
