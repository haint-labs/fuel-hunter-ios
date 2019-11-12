//
//  StringLocalizationExtension.swift
//  fuelhunter
//
//  Created by Guntis on 12/11/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

public extension String {

    func localized() -> String {
    	return AppSettingsWorker.shared.languageBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
