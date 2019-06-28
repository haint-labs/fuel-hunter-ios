//
//  PriceWorker.swift
//  fuelhunter
//
//  Created by Guntis on 26/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

class PriceWorker {
	var priceStore: PricesStoreProtocol

	init(priceStore: PricesStoreProtocol) {
		self.priceStore = priceStore
	}

	func fetchPrices(completionHandler: @escaping ([Price]) -> Void) {
    	priceStore.fetchPrices { (prices: () throws -> [Price]) -> Void in
			do {
				let prices = try prices()
        		DispatchQueue.main.async {
          			completionHandler(prices)
        		}
			} catch {
        		DispatchQueue.main.async {
          			completionHandler([])
        		}
      		}
		}
	}

  	func createPrice(priceToCreate: Price, completionHandler: @escaping (Price?) -> Void) {
    	priceStore.createPrice(priceToCreate: priceToCreate) { (price: () throws -> Price?) -> Void in
      		do {
        		let price = try price()
        		DispatchQueue.main.async {
          			completionHandler(price)
        		}
      		} catch {
        		DispatchQueue.main.async {
          			completionHandler(nil)
        		}
      		}
    	}
  	}

  	func updatePrice(priceToUpdate: Price, completionHandler: @escaping (Price?) -> Void)
  	{
    	priceStore.updatePrice(priceToUpdate: priceToUpdate) { (price: () throws -> Price?) in
      		do {
        		let price = try price()
        		DispatchQueue.main.async {
          			completionHandler(price)
        		}
      		} catch {
        		DispatchQueue.main.async {
          			completionHandler(nil)
        		}
      		}
    	}
  	}
}

// MARK: - Price store API

protocol PricesStoreProtocol {

  	// MARK: CRUD operations - Optional error
  
	func fetchPrices(completionHandler: @escaping ([Price], PricesStoreError?) -> Void)
	func fetchPrice(id: String, completionHandler: @escaping (Price?, PricesStoreError?) -> Void)
	func createPrice(priceToCreate: Price, completionHandler: @escaping (Price?, PricesStoreError?) -> Void)
	func updatePrice(priceToUpdate: Price, completionHandler: @escaping (Price?, PricesStoreError?) -> Void)
	func deletePrice(id: String, completionHandler: @escaping (Price?, PricesStoreError?) -> Void)

	// MARK: CRUD operations - Generic enum result type

	func fetchPrices(completionHandler: @escaping PricesStoreFetchPricesCompletionHandler)
	func fetchPrice(id: String, completionHandler: @escaping PricesStoreFetchPriceCompletionHandler)
	func createPrice(priceToCreate: Price, completionHandler: @escaping PricesStoreCreatePriceCompletionHandler)
	func updatePrice(priceToUpdate: Price, completionHandler: @escaping PricesStoreUpdatePriceCompletionHandler)
	func deletePrice(id: String, completionHandler: @escaping PricesStoreDeletePriceCompletionHandler)

	// MARK: CRUD operations - Inner closure

	func fetchPrices(completionHandler: @escaping (() throws -> [Price]) -> Void)
	func fetchPrice(id: String, completionHandler: @escaping (() throws -> Price?) -> Void)
	func createPrice(priceToCreate: Price, completionHandler: @escaping (() throws -> Price?) -> Void)
	func updatePrice(priceToUpdate: Price, completionHandler: @escaping (() throws -> Price?) -> Void)
	func deletePrice(id: String, completionHandler: @escaping (() throws -> Price?) -> Void)
}

protocol PricesStoreUtilityProtocol {}

extension PricesStoreUtilityProtocol {
	func generatePriceID(price: inout Price) {
  		// If it is not empty, then return
    	guard price.id.isEmpty else { return }
    	price.id = "\(arc4random())"
  	}
}

// MARK: - Orders store CRUD operation results

typealias PricesStoreFetchPricesCompletionHandler = (PricesStoreResult<[Price]>) -> Void
typealias PricesStoreFetchPriceCompletionHandler = (PricesStoreResult<Price>) -> Void
typealias PricesStoreCreatePriceCompletionHandler = (PricesStoreResult<Price>) -> Void
typealias PricesStoreUpdatePriceCompletionHandler = (PricesStoreResult<Price>) -> Void
typealias PricesStoreDeletePriceCompletionHandler = (PricesStoreResult<Price>) -> Void

enum PricesStoreResult<U> {
	case Success(result: U)
	case Failure(error: PricesStoreError)
}

// MARK: - Orders store CRUD operation errors

enum PricesStoreError: Equatable, Error {
	case CannotFetch(String)
	case CannotCreate(String)
	case CannotUpdate(String)
	case CannotDelete(String)
}

func ==(lhs: PricesStoreError, rhs: PricesStoreError) -> Bool {
	switch (lhs, rhs) {
		case (.CannotFetch(let a), .CannotFetch(let b)) where a == b: return true
		case (.CannotCreate(let a), .CannotCreate(let b)) where a == b: return true
		case (.CannotUpdate(let a), .CannotUpdate(let b)) where a == b: return true
		case (.CannotDelete(let a), .CannotDelete(let b)) where a == b: return true
		default: return false
	}
}
