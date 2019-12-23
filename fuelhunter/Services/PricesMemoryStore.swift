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
	
	static var address1 = Address(name: "Senču iela 2b", latitude: 56.968288, longitude: 24.1424928)
	static var address2 = Address(name: "Katoļu 4", latitude: 56.940759, longitude: 24.1358849)
	static var address3 = Address(name: "Kurzemes prospekts 4", latitude: 56.9543108, longitude: 24.0315306)
	static var address4 = Address(name: "Lugažu 6", latitude: 56.9749415, longitude: 24.1059608)
	static var address5 = Address(name: "Brīvības iela 82a", latitude: 56.9590876, longitude: 24.1253796)
	static var address6 = Address(name: "Uzvaras bulvāris 16", latitude: 56.9361106, longitude: 24.0892882)
	static var address7 = Address(name: "Lucavsalas iela 1, iebrauktuve no sētas puses", latitude: 56.9249891, longitude: 24.1106849)
	
	static var companyNeste = Company(companyType: .typeNeste, name: "Neste", logoName: "neste_logo", largeLogoName: "neste_big_logo", mapLogoName: "neste_map_logo", mapGrayLogoName: "neste_map_gray_logo", homePage: "https://www.neste.lv/lv/content/degvielas-cenas")
	static var companyCircleK = Company(companyType: .typeCircleK, name: "CircleK", logoName: "circle_k_logo", largeLogoName: "circle_k_big_logo", mapLogoName: "circle_k_map_logo", mapGrayLogoName: "circle_k_map_gray_logo", homePage: "https://www.circlek.lv/lv_LV/pg1334072578525/private/Degviela/Cenas.html")
	static var companyKool = Company(companyType: .typeKool, name: "Kool", logoName: "kool_logo", largeLogoName: "kool_big_logo", mapLogoName: "kool_map_logo", mapGrayLogoName: "kool_map_gray_logo", homePage: "https://kool.lv/degviela/")
	static var companyLatvijasNafta = Company(companyType: .typeLN, name: "Latvijas Nafta", logoName: "ln_logo", largeLogoName: "ln_big_logo", mapLogoName: "ln_map_logo", mapGrayLogoName: "ln_map_gray_logo", homePage: "http://www.lnafta.lv/lv/start/dus-tikls")
	static var companyVirsi = Company(companyType: .typeVirsi, name: "Virši", logoName: "virshi_logo", largeLogoName: "virshi_big_logo", mapLogoName: "virshi_map_logo", mapGrayLogoName: "virshi_map_gray_logo", homePage: "https://virsi.lv/lv/degvielas-cenas")
	static var companyGotikaAuto = Company(companyType: .typeGotikaAuto, name: "Gotika Auto", logoName: "gotika_logo", largeLogoName: "gotika_big_logo", mapLogoName: "gotika_map_logo", mapGrayLogoName: "gotika_map_gray_logo", homePage: "http://www.gotikaauto.lv")


  	static var prices = [
    	Price(id: "1", company: companyVirsi, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .typeDD, address: [address6]),
    	Price(id: "3", company: companyVirsi, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .type95, address: [address2]),
    	Price(id: "91", company: companyKool, city: "Rīga", price:"1.013", isPriceCheapest: true, fuelType: .type95, address: [address1]),
    	Price(id: "4", company: companyLatvijasNafta, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .typeDD, address: [address4]),
    	Price(id: "5", company: companyCircleK, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .type95, address: [address3]),
    	Price(id: "7", company: companyNeste, city: "Rīga", price:"1.254", isPriceCheapest: false, fuelType: .type95, address: [address7, address2]),
    	Price(id: "8", company: companyGotikaAuto, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .typeDD, address: [address5]),
    	Price(id: "90", company: companyKool, city: "Rīga", price:"1.012", isPriceCheapest: true, fuelType: .type98, address: [address1]),
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
