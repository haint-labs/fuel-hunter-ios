//
//  AppFonts.swift
//  fuelhunter
//
//  Created by Guntis on 30/05/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

struct Font {
    enum FontType: String {
        case normal = "HelveticaNeue"
        case medium = "HelveticaNeue-Medium"
        case bold   = "HelveticaNeue-Bold"
    }
    enum FontSize: Int {
        case size1 = 21
        case size2 = 19
        case size3 = 17
        case size4 = 15
        case size5 = 14
    }

    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }

    var font: UIFont {
        var instanceFont: UIFont!

		guard let aFont =  UIFont(name: type.rawValue, size: CGFloat(size.rawValue)) else {
			fatalError("""
			font is not installed, make sure it is added in Info.plist"
			"and logged with Utility.logAllAvailableFonts()
			""")
		}
		instanceFont = aFont

        return instanceFont
	}
}

//struct AppFonts {

//    HelveticaNeue-UltraLightItalic
//   HelveticaNeue-Medium
//   HelveticaNeue-MediumItalic
//   HelveticaNeue-UltraLight
//   HelveticaNeue-Italic
//   HelveticaNeue-Light
//   HelveticaNeue-ThinItalic
//   HelveticaNeue-LightItalic
//   HelveticaNeue-Bold
//   HelveticaNeue-Thin
//   HelveticaNeue-CondensedBlack
//   HelveticaNeue
//   HelveticaNeue-CondensedBold
//   HelveticaNeue-BoldItalic
//   
//}

class Utility {
	class func doit() {

		let aab = Font(.bold, size: .size5).font

		print("font \(aab)")
	}
//	/// Logs all available fonts from iOS SDK and installed custom font
//	class func logAllAvailableFonts() {
//		for family in UIFont.familyNames {
//			print("\(family)")
//			for name in UIFont.fontNames(forFamilyName: family) {
//				print("   \(name)")
//			}
//		}
//	}
}
