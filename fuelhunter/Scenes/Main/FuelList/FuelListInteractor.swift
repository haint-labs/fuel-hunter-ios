//
//  FuelListInteractor.swift
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

protocol FuelListBusinessLogic {
	func fetchPrices(request: FuelList.FetchPrices.Request)
	func prepareToRevealMapWithRequest(request: FuelList.RevealMap.Request)
	func getDisplayedPriceObject(request: FuelList.FindAPrice.Request) -> FuelList.FetchPrices.ViewModel.DisplayedPrice
}

protocol FuelListDataStore {
	//var name: String { get set }
}

class FuelListInteractor: FuelListBusinessLogic, FuelListDataStore {
	
	var presenter: FuelListPresentationLogic?
	var worker: FuelListWorker?
	//var name: String = ""

	var pricesWorker = PriceWorker(priceStore: PricesMemoryStore())
  	var prices: [Price]?
  
	// MARK: Do something

	func fetchPrices(request: FuelList.FetchPrices.Request) {

		pricesWorker.fetchPrices { (fetchedPrices) -> Void in
			self.prices = fetchedPrices
			let response = FuelList.FetchPrices.Response(prices: fetchedPrices)
			self.presenter?.presentSomething(response: response)
		}
	}

	func prepareToRevealMapWithRequest(request: FuelList.RevealMap.Request) {

		let response = FuelList.RevealMap.Response(prices: self.prices!, selectedCompany: request.selectedCompany, selectedFuelType: request.selectedFuelType, selectedCellYPosition: request.selectedCellYPosition)

		self.presenter?.revealMapView(response: response)
	}


	func getDisplayedPriceObject(request: FuelList.FindAPrice.Request) -> FuelList.FetchPrices.ViewModel.DisplayedPrice {

		return FuelList.FetchPrices.ViewModel.DisplayedPrice.init(id: request.selectedPrice.id, company: request.selectedPrice.company, price: request.selectedPrice.price, isPriceCheapest: request.selectedPrice.isPriceCheapest, fuelType: request.selectedPrice.fuelType, addressDescription: request.selectedPrice.addressDescription, address: request.selectedPrice.address, city: request.selectedPrice.city)
	}
}
