//
//  CompanyChangesPresenter.swift
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

protocol CompanyChangesPresentationLogic {
  	func presentData(response: CompanyChanges.List.Response)
  	func returnBackToPreviousViewController()
}

class CompanyChangesPresenter: CompanyChangesPresentationLogic {
  	weak var viewController: CompanyChangesDisplayLogic?
	weak var router: CompanyChangesRouter?

  	// MARK: CompanyChangesPresentationLogic

  	func presentData(response: CompanyChanges.List.Response) {

		var addedCompanies = [CompanyChanges.List.ViewModel.DisplayedCompanyCellItem]()
		var removedCompanies = [CompanyChanges.List.ViewModel.DisplayedCompanyCellItem]()

		let language = AppSettingsWorker.shared.getCurrentLanguage()


		var count = 0

		for company in response.fetchedAddedCompanies {
			count += 1
			let languageString: String

			switch language {
				case .latvian:
					languageString = company.descriptionLV ?? ""
				case .russian:
					languageString = company.descriptionRU ?? ""
				case .english:
					languageString = company.descriptionEN ?? ""
				case .latgalian:
					languageString = company.descriptionLV ?? ""
			}

			let title = company.name ?? ""
			let imageName = company.logoName ?? ""

			addedCompanies.append(CompanyChanges.List.ViewModel.DisplayedCompanyCellItem(companyWasAdded: true, title: title, description: languageString, imageName: imageName, toggleStatus: company.isEnabled))


			if count > 2 {
				break
			}
		}

		count = 0

		for company in response.fetchedRemovedCompanies {
			count += 1
			let languageString: String

			switch language {
				case .latvian:
					languageString = company.descriptionLV ?? ""
				case .russian:
					languageString = company.descriptionRU ?? ""
				case .english:
					languageString = company.descriptionEN ?? ""
				case .latgalian:
					languageString = company.descriptionLV ?? ""
			}

			let title = company.name ?? ""
			let imageName = company.logoName ?? ""

			removedCompanies.append(CompanyChanges.List.ViewModel.DisplayedCompanyCellItem(title: title, description: languageString, imageName: imageName))

			if count > 1 {
				break
			}
		}

		var combinedArray = [[CompanyChanges.List.ViewModel.DisplayedCompanyCellItem]]()

		if addedCompanies.isEmpty == false {
			combinedArray.append(addedCompanies)
		}

		if removedCompanies.isEmpty == false {
			combinedArray.append(removedCompanies)
		}

    	let viewModel = CompanyChanges.List.ViewModel(displayedCompanyCellItems: combinedArray)
    	
    	viewController?.updateData(viewModel: viewModel)
  	}

  	func returnBackToPreviousViewController() {
  		router?.dismissCurrentViewController()
  	}
}
