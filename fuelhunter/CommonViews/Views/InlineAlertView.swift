//
//  InlineAlertView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class InlineAlertView: UIView {

	@IBOutlet weak var inlineAlertView: UIView!
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!
	var expanded = false

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		if expanded {
			self.heightConstraint.constant = textLabel.frame.height+10
		} else { 
			self.heightConstraint.constant = 0
		}
	}

	func setup() {
		Bundle.main.loadNibNamed("InlineAlertView", owner: self, options: nil)
		addSubview(inlineAlertView)
		inlineAlertView.frame = self.bounds
		expanded = true
  	}

	// Functions

	@IBAction func inlineAlertWasPressed(_ sender: Any) {
		expanded = false
		UIView.animate(withDuration: 0.3) {
			self.heightConstraint.constant = 0
				self.layoutIfNeeded()
				self.superview?.layoutIfNeeded()
		}
	}
}
