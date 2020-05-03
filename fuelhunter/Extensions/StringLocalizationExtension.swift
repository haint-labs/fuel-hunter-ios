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

    func localizedToRU() -> String {
		return AppSettingsWorker.shared.ruLanguageBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    func localizedToEN() -> String {
		return AppSettingsWorker.shared.enLanguageBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    func localizedToLV() -> String {
		return AppSettingsWorker.shared.lvLanguageBundle.localizedString(forKey: self, value: nil, table: nil)
    }

    func localizedToLG() -> String {
		return AppSettingsWorker.shared.lgLanguageBundle.localizedString(forKey: self, value: nil, table: nil)
    }
}
