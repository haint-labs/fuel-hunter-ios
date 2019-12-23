//
//  FontChangeTableViewCell.swift
//  fuelhunter
//
//  Created by Guntis on 08/12/2019.
//  Copyright © 2019 myEmerg. All rights reserved.
//

import UIKit

protocol FontChangeTableViewCellNotifications {
	func fontSizeWasChanged()
}

class FontChangeTableViewCell: UITableViewCell, FontChangeTableViewCellNotifications {

    override func awakeFromNib() {
        super.awakeFromNib()

        NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
	}

	deinit {
		NotificationCenter.default.removeObserver(self, name: .fontSizeWasChanged, object: nil)
	}

	// MARK: FontChangeTableViewCellNotifications
	@objc func fontSizeWasChanged() {
		// override
	}
}
