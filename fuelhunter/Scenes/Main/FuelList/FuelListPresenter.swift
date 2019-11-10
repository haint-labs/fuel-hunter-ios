//
//  FuelListPresenter.swift
//  fuelhunter
//
//  Created by Guntis on 03/06/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol FuelListPresentationLogic {
	func presentSomething(response: FuelList.FetchPrices.Response)
	func revealMapView(response: FuelList.RevealMap.Response)
}

class FuelListPresenter: FuelListPresentationLogic {
	weak var viewController: FuelListDisplayLogic?

	// MARK: FuelListPresentationLogic

	func presentSomething(response: FuelList.FetchPrices.Response) {

		var displayedPrices: [[FuelList.FetchPrices.ViewModel.DisplayedPrice]] = []

		let type95Prices = self.getPrices(with: .type95, from: response.prices)
		let type98Prices = self.getPrices(with: .type98, from: response.prices)
		let typeDDPrices = self.getPrices(with: .typeDD, from: response.prices)
		let typeDDProPrices = self.getPrices(with: .typeDDPro, from: response.prices)
		let typeGasPrices = self.getPrices(with: .typeGas, from: response.prices)
		
		if !type95Prices.isEmpty { displayedPrices.append(type95Prices) }
		if !type98Prices.isEmpty { displayedPrices.append(type98Prices) }
		if !typeDDPrices.isEmpty { displayedPrices.append(typeDDPrices) }
		if !typeDDProPrices.isEmpty { displayedPrices.append(typeDDProPrices) }
		if !typeGasPrices.isEmpty { displayedPrices.append(typeGasPrices) }

		let viewModel = FuelList.FetchPrices.ViewModel(displayedPrices: displayedPrices)
		viewController?.displaySomething(viewModel: viewModel)
	}


	func revealMapView(response: FuelList.RevealMap.Response) {

		let necessaryPrices = response.prices.filter( { $0.fuelType == response.selectedFuelType })

		let viewModel = FuelList.RevealMap.ViewModel.init(slectedFuelTypePrices: necessaryPrices, selectedCompany: response.selectedCompany, selectedFuelType: response.selectedFuelType, selectedCellYPosition: response.selectedCellYPosition)

		viewController?.revealMapView(viewModel: viewModel)
	}

	// MARK: Functions

	func getPrices(with type: FuelType, from prices: [Price]) -> [FuelList.FetchPrices.ViewModel.DisplayedPrice] {

		let pricesToReturn = prices.filter( { $0.fuelType == type }).map( {
			return FuelList.FetchPrices.ViewModel.DisplayedPrice.init(id: $0.id, company: $0.company, price: $0.price, isPriceCheapest: $0.isPriceCheapest, fuelType: $0.fuelType, addressDescription: $0.addressDescription, address: $0.address, city: $0.city)
		} )

		return pricesToReturn
	}
}
