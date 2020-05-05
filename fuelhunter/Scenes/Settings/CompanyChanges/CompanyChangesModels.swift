//
//  CompanyChanges.swift
//  fuelhunter
//
//  Created by Guntis on 10/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

enum CompanyChanges {
  	// MARK: Use cases
  	enum SwitchToggled {
		struct Request {
			var companyName: String
			var state: Bool
		}
	}
	enum List {
		struct Request {
		}
		struct Response {
			var fetchedAddedCompanies: [CompanyEntity]
			var fetchedRemovedCompanies: [CompanyEntity]
		}
		struct ViewModel {
			struct DisplayedCompanyCellItem: Equatable {
				var companyWasAdded: Bool = false
				var title: String
				var description: String
				var imageName: String
				var toggleStatus: Bool = false
			}
			var displayedCompanyCellItems: [[DisplayedCompanyCellItem]]
		}
  	}
}