//
//  AppLanguagePresenter.swift
//  fuelhunter
//
//  Created by Guntis on 05/07/2019.
//  Copyright (c) 2019 . All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol AppLanguagePresentationLogic {
  	func presentLanguageList(response: AppLanguage.GetLanguage.Response)
}

class AppLanguagePresenter: AppLanguagePresentationLogic {
  	weak var viewController: AppLanguageDisplayLogic?

  	// MARK: AppLanguagePresentationLogic

  	func presentLanguageList(response: AppLanguage.GetLanguage.Response) {
  		let currentlyActiveLanguage = response.activeLanguage
  		let array =  [
			AppLanguage.GetLanguage.ViewModel.DisplayedLanguageCellItem.init(currentlyActive: currentlyActiveLanguage == .languageLatvian, languageName: "Latviski", languageNameTranslated: "Latviski"),
			AppLanguage.GetLanguage.ViewModel.DisplayedLanguageCellItem.init(currentlyActive: currentlyActiveLanguage == .languageEnglish, languageName: "English", languageNameTranslated: "Angliski"),
			AppLanguage.GetLanguage.ViewModel.DisplayedLanguageCellItem.init(currentlyActive: currentlyActiveLanguage == .languageRussian, languageName: "Русский", languageNameTranslated: "Krieviski")
			]
    	let viewModel = AppLanguage.GetLanguage.ViewModel(displayedLanguageCellItems: array)
    	viewController?.presentLanguageList(viewModel: viewModel)
  	}
}