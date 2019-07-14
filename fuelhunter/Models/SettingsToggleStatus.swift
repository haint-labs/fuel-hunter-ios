//
//  SettingsToggleStatus.swift
//  fuelhunter
//
//  Created by Guntis on 12/07/2019.
//  Copyright © 2019 . All rights reserved.
//


enum SettingsToggleResult<Value> {
	case success(Value)
	case needsSetUp
	case failure(String)
}



//extension ValidationError: LocalizedError {
//    var errorDescription: String? {
//        switch self {
//        case .tooShort:
//            return NSLocalizedString(
//                "Your username needs to be at least 4 characters long",
//                comment: ""
//            )
//        case .tooLong:
//            return NSLocalizedString(
//                "Your username can't be longer than 14 characters",
//                comment: ""
//            )
//        case .invalidCharacterFound(let character):
//            let format = NSLocalizedString(
//                "Your username can't contain the character '%@'",
//                comment: ""
//            )
//
//            return String(format: format, String(character))
//        }
//    }
//}
