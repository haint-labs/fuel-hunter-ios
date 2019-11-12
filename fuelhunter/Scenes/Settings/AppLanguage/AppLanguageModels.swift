//
//  AppLanguageModels.swift
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

enum AppLanguage {
  	// MARK: Use cases

	enum GetLanguage {
		struct Request {
		}
		struct Response {
			var activeLanguage: AppSettingsWorker.Language
		}
		struct ViewModel {
			struct DisplayedLanguageCellItem: Equatable {
				var language: AppSettingsWorker.Language
				var currentlyActive: Bool
				//This will be language name
				var languageName: String
				// language name in original language
				var languageNameInOriginalLanguage: String
			}
			var displayedLanguageCellItems: [DisplayedLanguageCellItem]
		}
  	}
  	enum ChangeLanguage {
		struct Request {
			var selectedLanguage: AppSettingsWorker.Language
		}
  	}
}
