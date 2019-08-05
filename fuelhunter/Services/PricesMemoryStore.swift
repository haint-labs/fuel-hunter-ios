//
//  PricesMemoryStore.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

class PricesMemoryStore: PricesStoreProtocol, PricesStoreUtilityProtocol {
	// MARK: - Data
	//  Senču iela 2b, \nKatoļu 4, Kurzemes prospekts 4, \nLugažu 6, Brīvības iela 82a
	
	static var address1 = Address.init(name: "Senču iela 2b", latitude: 0, longitude: 0)
	static var address2 = Address.init(name: "Katoļu 4", latitude: 0, longitude: 0)
	static var address3 = Address.init(name: "Kurzemes prospekts 4", latitude: 0, longitude: 0)
	static var address4 = Address.init(name: "Lugažu 6", latitude: 0, longitude: 0)
	static var address5 = Address.init(name: "Brīvības iela 82a", latitude: 0, longitude: 0)
	
	static var companyNeste = Company.init(companyType: .typeNeste, name: "Neste", logoName: "neste_logo")
	static var companyCircleK = Company.init(companyType: .typeCircleK, name: "CircleK", logoName: "circle_k_logo")
	static var companyKool = Company.init(companyType: .typeKool, name: "Kool", logoName: "kool_logo")
	static var companyLatvijasNafta = Company.init(companyType: .typeLN, name: "Latvijas Nafta", logoName: "ln_logo")
	static var companyVirsi = Company.init(companyType: .typeVirsi, name: "Virši", logoName: "virshi_logo")
	static var companyGotikaAuto = Company.init(companyType: .typeGotikaAuto, name: "Gotika Auto", logoName: "gotika_logo")
//	static var companyViada = Company.init(companyType: .typeViada, name: "Viada", logoName: "viada_logo")
//	static var companyAstarte = Company.init(companyType: .typeAstarte, name: "Astarte", logoName: "astarte_logo")
//	static var companyDinaz = Company.init(companyType: .typeDinaz, name: "Dinaz", logoName: "dinaz_logo")
//	static var companyLPG = Company.init(companyType: .typeLPG, name: "CircleK", logoName: "lpg_logo")

  	static var prices = [
    	Price(id: "1", company: companyVirsi, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .typeDD, address: [address1, address2, address3, address4, address5]),
//    	Price(id: "2", company: companyAstarte, city: "Rīga", price:"1.012", isPriceCheapest: true, gasType: .typeDD, address: [address1, address4, address5]),
    	Price(id: "3", company: companyKool, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .type95, address: [address1]),
    	Price(id: "91", company: companyKool, city: "Rīga", price:"1.013", isPriceCheapest: true, fuelType: .type95, address: [address1]),
    	Price(id: "4", company: companyLatvijasNafta, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .typeDD, address: [address1, address2, address3, address4, address5]),
    	Price(id: "5", company: companyCircleK, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .typeDD, address: [address1, address4, address5]),
//    	Price(id: "6", company: companyViada, city: "Rīga", price:"1.012", isPriceCheapest: true, gasType: .type95, address: [address1, address5]),
    	Price(id: "7", company: companyNeste, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .typeDD, address: [address1, address2, address3, address4, address5]),
    	Price(id: "8", company: companyGotikaAuto, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .typeDD, address: [address1, address4, address5]),
//    	Price(id: "9", company: companyDinaz, city: "Rīga", price:"1.012", isPriceCheapest: true, gasType: .type95, address: [address1, address5]),
    	Price(id: "90", company: companyKool, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .type98, address: [address1]),
//    	Price(id: "10", company: companyLPG, city: "Rīga", price:"1.012", isPriceCheapest: true, gasType: .typeGas, address: [address1, address4, address3])
  	]
  
  	// MARK: - CRUD operations - Optional error
  
  	func fetchPrices(completionHandler: @escaping ([Price], PricesStoreError?) -> Void) {
    	completionHandler(type(of: self).prices, nil)
  	}
  
  	func fetchPrice(id: String, completionHandler: @escaping (Price?, PricesStoreError?) -> Void) {
    	if let index = indexOfPriceWithID(id: id) {
      		let price = type(of: self).prices[index]
      		completionHandler(price, nil)
    	} else {
      		completionHandler(nil, PricesStoreError.CannotFetch("Cannot fetch price with id \(id)"))
    	}
  	}
  
  	func createPrice(priceToCreate: Price, completionHandler: @escaping (Price?, PricesStoreError?) -> Void) {
    	var price = priceToCreate
    	generatePriceID(price: &price)
    	// Generate distance?
    	type(of: self).prices.append(price)
    	completionHandler(price, nil)
  	}
  
  	func updatePrice(priceToUpdate: Price, completionHandler: @escaping (Price?, PricesStoreError?) -> Void) {
    	if let index = indexOfPriceWithID(id: priceToUpdate.id) {
      		type(of: self).prices[index] = priceToUpdate
      		let price = type(of: self).prices[index]
      		completionHandler(price, nil)
    	} else {
      		completionHandler(nil, PricesStoreError.CannotUpdate("Cannot fetch Price with id \(String(describing: priceToUpdate.id)) to update"))
    	}
  	}
  
  	func deletePrice(id: String, completionHandler: @escaping (Price?, PricesStoreError?) -> Void) {
    	if let index = indexOfPriceWithID(id: id) {
      		let price = type(of: self).prices.remove(at: index)
      		completionHandler(price, nil)
      		return
    	}
    	completionHandler(nil, PricesStoreError.CannotDelete("Cannot fetch Price with id \(id) to delete"))
  	}
  
  	// MARK: - CRUD operations - Generic enum result type
  
  	func fetchPrices(completionHandler: @escaping PricesStoreFetchPricesCompletionHandler) {
    	completionHandler(PricesStoreResult.Success(result: type(of: self).prices))
  	}
  
	func fetchPrice(id: String, completionHandler: @escaping PricesStoreFetchPriceCompletionHandler) {
    	let price = type(of: self).prices.filter { (price: Price) -> Bool in
      		return price.id == id
      	}.first
		if let price = price {
      		completionHandler(PricesStoreResult.Success(result: price))
    	} else {
      		completionHandler(PricesStoreResult.Failure(error: PricesStoreError.CannotFetch("Cannot fetch Price with id \(id)")))
    	}
  	}
  
  	func createPrice(priceToCreate: Price, completionHandler: @escaping PricesStoreCreatePriceCompletionHandler) {
    	var price = priceToCreate
    	generatePriceID(price: &price)
    	// Generate distance?
    	type(of: self).prices.append(price)
    	completionHandler(PricesStoreResult.Success(result: price))
  	}
  
  	func updatePrice(priceToUpdate: Price, completionHandler: @escaping PricesStoreUpdatePriceCompletionHandler) {
    	if let index = indexOfPriceWithID(id: priceToUpdate.id) {
      		type(of: self).prices[index] = priceToUpdate
      		let price = type(of: self).prices[index]
      		completionHandler(PricesStoreResult.Success(result: price))
    	} else {
      		completionHandler(PricesStoreResult.Failure(error: PricesStoreError.CannotUpdate("Cannot update Price with id \(String(describing: priceToUpdate.id)) to update")))
    	}
  	}
  
  	func deletePrice(id: String, completionHandler: @escaping PricesStoreDeletePriceCompletionHandler) {
    	if let index = indexOfPriceWithID(id: id) {
      		let price = type(of: self).prices.remove(at: index)
      		completionHandler(PricesStoreResult.Success(result: price))
      		return
		}
    	completionHandler(PricesStoreResult.Failure(error: PricesStoreError.CannotDelete("Cannot delete Price with id \(id) to delete")))
  	}
  
  	// MARK: - CRUD operations - Inner closure
  
  	func fetchPrices(completionHandler: @escaping (() throws -> [Price]) -> Void) {
    	completionHandler { return type(of: self).prices }
  	}
  
  	func fetchPrice(id: String, completionHandler: @escaping (() throws -> Price?) -> Void) {
    	if let index = indexOfPriceWithID(id: id) {
      		completionHandler { return type(of: self).prices[index] }
    	} else {
      		completionHandler { throw PricesStoreError.CannotFetch("Cannot fetch Price with id \(id)") }
    	}
  	}
  
  	func createPrice(priceToCreate: Price, completionHandler: @escaping (() throws -> Price?) -> Void) {
    	var price = priceToCreate
    	generatePriceID(price: &price)
    	// Generate distance?
    	type(of: self).prices.append(price)
    	completionHandler { return price }
  	}
  
  	func updatePrice(priceToUpdate: Price, completionHandler: @escaping (() throws -> Price?) -> Void) {
    	if let index = indexOfPriceWithID(id: priceToUpdate.id) {
      		type(of: self).prices[index] = priceToUpdate
      		let price = type(of: self).prices[index]
      		completionHandler { return price }
		} else {
      		completionHandler { throw PricesStoreError.CannotUpdate("Cannot fetch Price with id \(String(describing: priceToUpdate.id)) to update") }
    	}
  	}
  
  	func deletePrice(id: String, completionHandler: @escaping (() throws -> Price?) -> Void) {
    	if let index = indexOfPriceWithID(id: id) {
      		let price = type(of: self).prices.remove(at: index)
      		completionHandler { return price }
    	} else {
      		completionHandler { throw PricesStoreError.CannotDelete("Cannot fetch Price with id \(id) to delete") }
    	}
  	}

  	// MARK: - Convenience methods
  
	private func indexOfPriceWithID(id: String?) -> Int? {
		return type(of: self).prices.firstIndex { return $0.id == id }
	}
}
