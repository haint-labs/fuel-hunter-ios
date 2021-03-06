//
//  IntroChooseFuelTypePresenter.swift
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

protocol IntroChooseFuelTypePresentationLogic {
  	func presentData(response: IntroChooseFuelType.FuelCells.Response)
}

class IntroChooseFuelTypePresenter: IntroChooseFuelTypePresentationLogic {
  	weak var viewController: IntroChooseFuelTypeDisplayLogic?

  	// MARK: IntroChooseFuelTypePresentationLogic

  	func presentData(response: IntroChooseFuelType.FuelCells.Response) {
    	let array =  [
			IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .typeDD, title: "fuel_dd", toggleStatus: response.statusOfDD),
			IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .type95, title: "fuel_95", toggleStatus: response.statusOf95),
			IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .type98, title: "fuel_98", toggleStatus: response.statusOf98),
			IntroChooseFuelType.FuelCells.ViewModel.DisplayedFuelCellItem(fuelType: .typeGas, title: "fuel_gas", toggleStatus: response.statusOfGas)
			]

    	let viewModel = IntroChooseFuelType.FuelCells.ViewModel(nextButtonIsEnabled: response.statusOfNextButton, displayedFuelCellItems: array)
    	viewController?.displayListWithData(viewModel: viewModel)
  	}
}
