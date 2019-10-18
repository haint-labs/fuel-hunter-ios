//
//  IntroChooseFuelTypeInteractor.swift
//  fuelhunter
//
//  Created by Guntis on 25/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol IntroChooseFuelTypeBusinessLogic {
  	func getFuelTypesListData(request: IntroChooseFuelType.FuelCells.Request)
  	func userToggledFuelType(request: IntroChooseFuelType.SwitchToggled.Request)
}

protocol IntroChooseFuelTypeDataStore {
  	//var name: String { get set }
}

class IntroChooseFuelTypeInteractor: IntroChooseFuelTypeBusinessLogic, IntroChooseFuelTypeDataStore {
  	var presenter: IntroChooseFuelTypePresentationLogic?
  	var appSettingsWorker = AppSettingsWorker.shared
  	//var name: String = ""

  	// MARK: IntroChooseFuelTypeBusinessLogic

  	func getFuelTypesListData(request: IntroChooseFuelType.FuelCells.Request) {
    	let fuelTypes = appSettingsWorker.getFuelTypeToggleStatus()
    	let response = IntroChooseFuelType.FuelCells.Response.init(statusOfDD: fuelTypes.typeDD, statusOfProDD: fuelTypes.typeDDPro, statusOf95: fuelTypes.type95, statusOf98: fuelTypes.type98, statusOfGas: fuelTypes.typeGas, statusOfNextButton: fuelTypes.isAtLeastOneTypeEnabled())
    	presenter?.presentData(response: response)
  	}

  	func userToggledFuelType(request: IntroChooseFuelType.SwitchToggled.Request) {
  		var fuelTypes = appSettingsWorker.getFuelTypeToggleStatus()
  		if request.fuelType == .type95 { fuelTypes.type95 = request.state }
  		if request.fuelType == .type98 { fuelTypes.type98 = request.state }
  		if request.fuelType == .typeDD { fuelTypes.typeDD = request.state }
  		if request.fuelType == .typeDDPro { fuelTypes.typeDDPro = request.state }
  		if request.fuelType == .typeGas { fuelTypes.typeGas = request.state }
  		appSettingsWorker.setFuelTypeToggleStatus(allFuelTypes: fuelTypes)
  		let request = IntroChooseFuelType.FuelCells.Request()
    	getFuelTypesListData(request: request)
  	}
}
