//
//  Area.swift
//  fuelhunter
//
//  Created by Guntis on 20/07/2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation

enum AreaType: Int {
	case areaTypeGPS = 0
	case areaTypeAdded = 1
	case areaTypeNew = 2
}

enum CellAccessoryType: Int {
	case cellAccessoryTypeNone = 0
	case cellAccessoryTypeName = 1
	case cellAccessoryTypeToggle = 2
	case cellAccessoryTypeCheckMark = 3
	case cellAccessoryTypeDelete = 4
}

enum CellFunctionalityType: Int {
	case cellFunctionalityTypeNone = 0
	case cellFunctionalityTypeName = 1
	case cellFunctionalityTypeCheapestOnly = 2
	case cellFunctionalityTypePushNotif = 3
	case cellFunctionalityTypeCompany = 4
	case cellFunctionalityTypeDelete = 5
}
