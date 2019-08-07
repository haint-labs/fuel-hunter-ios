//
//  AppAccuracyInfoLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 07/08/2019.
//  Copyright © 2019 myEmerg. All rights reserved.
//

import UIKit

class AppAccuracyInfoLayoutView: AboutAppLayoutView {

    override func setUpTableViewHeader() {
		header = AppAccuracyInfoTableHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: 100))
		header.translatesAutoresizingMaskIntoConstraints = false
		self.tableView.tableHeaderView = header
		header.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
		header.layoutIfNeeded()
		tableView.tableHeaderView = header
	}
}
