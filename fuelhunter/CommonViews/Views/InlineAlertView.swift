//
//  InlineAlertView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 myEmerg. All rights reserved.
//

import UIKit

class InlineAlertView: UIView {
	var expanded = false
	@IBOutlet weak var inlineAlertView: UIView!

	@IBOutlet weak var textLabel: UILabel!

	@IBOutlet weak var heightConstraint: NSLayoutConstraint!

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("InlineAlertView", owner: self, options: nil)
		addSubview(inlineAlertView)
		inlineAlertView.frame = self.bounds
		self.heightConstraint.constant = textLabel.frame.height+10
		self.layoutIfNeeded()
  	}

	@IBAction func inlineAlertWasPressed(_ sender: Any) {
		print("inlineAlertWasPressed")
		UIView.animate(withDuration: 0.3) {
			self.heightConstraint.constant = 0
				self.layoutIfNeeded()
				self.superview?.layoutIfNeeded()
		}

//		DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) {
//			UIView.animate(withDuration: 0.3) {
//				self.heightConstraint.constant = self.textLabel.frame.height+10
//				self.layoutIfNeeded()
//				self.superview?.layoutIfNeeded()
//			}
//		}
	}
}
