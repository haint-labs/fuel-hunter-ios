//
//  IntroChooseFuelTypeModels.swift
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

enum IntroChooseFuelType {
	enum SwitchToggled {
		struct Request {
			var fuelType: FuelType
			var state: Bool
		}
	}
	enum FuelCells {
		struct Request {
		}
		struct Response {
			var statusOfDD: Bool
			var statusOf95: Bool
			var statusOf98: Bool
			var statusOfGas: Bool
			var statusOfNextButton: Bool
		}
		struct ViewModel {
			struct DisplayedFuelCellItem: Equatable {
				var fuelType: FuelType
				var title: String
				var toggleStatus: Bool = false
			}
			var nextButtonIsEnabled: Bool = false
			var displayedFuelCellItems: [DisplayedFuelCellItem]
		}
  	}
}
