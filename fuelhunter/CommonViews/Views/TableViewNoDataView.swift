//
//  TableViewNoDataView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit


class TableViewNoDataView: UIView {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet var titleLabel: UILabel!
	@IBOutlet var loadingIndicator: UIActivityIndicatorView!

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("TableViewNoDataView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		titleLabel.translatesAutoresizingMaskIntoConstraints = false
		loadingIndicator.translatesAutoresizingMaskIntoConstraints = false

		baseView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		baseView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		baseView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		baseView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
		titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
		titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true

		loadingIndicator.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		loadingIndicator.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		loadingIndicator.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
		loadingIndicator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		titleLabel.font = Font(.normal, size: .size2).font
	}

	func set(title: String, loadingEnabled: Bool) {
		titleLabel.text = title
		if loadingEnabled {
			loadingIndicator.startAnimating()
		} else {
			loadingIndicator.stopAnimating()
		}
	}
}