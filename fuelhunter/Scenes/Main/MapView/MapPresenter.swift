//
//  MapPresenter.swift
//  fuelhunter
//
//  Created by Guntis on 12/08/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol MapPresentationLogic {
  	func presentSomething(response: Map.MapData.Response)
  	func updateToRevealMapPoint(response: Map.MapWasPressed.Response)
}

class MapPresenter: MapPresentationLogic {
  	weak var viewController: MapDisplayLogic?
	
  	// MARK: Do something

  	func presentSomething(response: Map.MapData.Response) {
		let viewModel = Map.MapData.ViewModel(displayedPoints: response.displayedPoints, mapPoints: response.mapPoints, selectedDisplayedPoint: response.selectedDisplayedPoint, selectedMapPoint: response.selectedMapPoint)
    	viewController?.displaySomething(viewModel: viewModel)
  	}

	func updateToRevealMapPoint(response: Map.MapWasPressed.Response) {
		let viewModel = Map.MapWasPressed.ViewModel.init(selectedDisplayedPoint: response.selectedDisplayedPoint, selectedMapPoint: response.selectedMapPoint, selectedPrice: response.selectedPrice)

		viewController?.updateToRevealMapPoint(viewModel: viewModel)
	}

}
