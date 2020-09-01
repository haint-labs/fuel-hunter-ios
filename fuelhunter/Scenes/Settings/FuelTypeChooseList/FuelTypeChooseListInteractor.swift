//
//  FuelTypeChooseListInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FuelTypeChooseListBusinessLogic {
  	func getFuelTypesListData(request: FuelTypeChooseList.FuelCells.Request)
  	func userToggledFuelType(request: FuelTypeChooseList.SwitchToggled.Request)
  	func reCheckFuelTypes()
  	func didUserAddAFuelType() -> Bool
}

protocol FuelTypeChooseListDataStore {
}

class FuelTypeChooseListInteractor: FuelTypeChooseListBusinessLogic, FuelTypeChooseListDataStore {
  	var presenter: FuelTypeChooseListPresentationLogic?
  	var appSettingsWorker = AppSettingsWorker.shared

	var fuelTypesThatWereEnabled = [FuelType]()

  	// MARK: FuelTypeChooseListBusinessLogic

  	func getFuelTypesListData(request: FuelTypeChooseList.FuelCells.Request) {
    	let fuelTypes = appSettingsWorker.getFuelTypeToggleStatus()
    	let response = FuelTypeChooseList.FuelCells.Response(statusOfDD: fuelTypes.typeDD, statusOf95: fuelTypes.type95, statusOf98: fuelTypes.type98, statusOfGas: fuelTypes.typeGas)
    	presenter?.presentData(response: response)
  	}

  	func userToggledFuelType(request: FuelTypeChooseList.SwitchToggled.Request) {
  		var fuelTypes = appSettingsWorker.getFuelTypeToggleStatus()

		if request.state == true {
			fuelTypesThatWereEnabled.append(request.fuelType)
		} else {
			fuelTypesThatWereEnabled.removeAll(where: {$0 == request.fuelType})
		}

  		if request.fuelType == .type95 { fuelTypes.type95 = request.state }
  		if request.fuelType == .type98 { fuelTypes.type98 = request.state }
  		if request.fuelType == .typeDD { fuelTypes.typeDD = request.state }
  		if request.fuelType == .typeGas { fuelTypes.typeGas = request.state }

  		appSettingsWorker.setFuelTypeToggleStatus(allFuelTypes: fuelTypes)

  		let request = FuelTypeChooseList.FuelCells.Request()
    	getFuelTypesListData(request: request)
  	}

  	func reCheckFuelTypes() {
		// This should happen when User moves out of fuel type choose list view, in settings.
		// Check if there is any fuel type enabled. If not, enable all. Or Diesel.
		var fuelTypes = appSettingsWorker.getFuelTypeToggleStatus()

		if !fuelTypes.isAtLeastOneTypeEnabled() {
			fuelTypes.setToDefault()
			fuelTypesThatWereEnabled.append(.type95) // Need only to add one, as it will result in download anyways.
			appSettingsWorker.setFuelTypeToggleStatus(allFuelTypes: fuelTypes)
		}
	}

	// If we just remove fuel types and leave view, then it's fine (as we have data covered it).
	// But if we add new type, then we better re-download all.
	func didUserAddAFuelType() -> Bool {
		return !fuelTypesThatWereEnabled.isEmpty
  	}
}
