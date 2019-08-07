//
//  CompaniesChooseListModels.swift
//  fuelhunter
//
//  Created by Guntis on 04/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CompaniesChooseList {
  	// MARK: Use cases
	enum SwitchToggled {
		struct Request {
			var companyType: CompanyType
			var state: Bool
		}
	}
	enum CompanyCells {
		struct Request {
		}
		struct Response {
			var companyCheapestStatus: Bool
			var companyNesteStatus: Bool
			var companyCircleKStatus: Bool
			var companyKoolStatus: Bool
			var companyLatvijasNaftaStatus: Bool
			var companyVirsiStatus: Bool
			var companyGotikaStatus: Bool
		}
		struct ViewModel {
			struct DisplayedCompanyCellItem: Equatable {
				var companyType: CompanyType
				var title: String
				var description: String
				var imageName: String
				var toggleStatus: Bool = false
			}
			var displayedCompanyCellItems: [DisplayedCompanyCellItem]
		}
  	}
}
