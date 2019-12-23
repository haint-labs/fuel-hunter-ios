//
//  AppFonts.swift
//  fuelhunter
//
//  Created by Guntis on 30/05/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

//https://graphemica.com/➊ ➋ ➌ ➍ ➎ ➏ ➐ ➑ ➒ ➓
 
struct Font {

	static var increaseFontSize: Int = -100 {
		didSet {
			// For first time setting and only if it changes..
			if oldValue != -100 && oldValue != increaseFontSize {
				print("change")
				NotificationCenter.default.post(name: .fontSizeWasChanged, object: nil)
			}
		}
	}

	static func recalculateFontIncreaseSize() {
		// Default should be 28. (From my testing.)
		print("before increase \(Font.increaseFontSize)")
		Font.increaseFontSize = min(10, Int(UIFont.preferredFont(forTextStyle: .title1).pointSize) - 28)
		print("after increase \(Font.increaseFontSize)")
	}

    enum FontType: String {
        case normal = "HelveticaNeue"
        case medium = "HelveticaNeue-Medium"
        case bold   = "HelveticaNeue-Bold"
    }
    enum FontSize: Int {
    	case size0 = 33
        case size1 = 21
        case size2 = 19
        case size3 = 17
        case size4 = 15
        case size5 = 14
        case size6 = 13
    }

    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }

    var font: UIFont {
        var instanceFont: UIFont!
		guard let aFont =  UIFont(name: type.rawValue, size: CGFloat(size.rawValue + Font.increaseFontSize)) else {
			fatalError("""
			font is not installed, make sure it is added in Info.plist"
			"and logged with Utility.logAllAvailableFonts()
			""")
		}
		instanceFont = aFont

        return instanceFont
	}
}
