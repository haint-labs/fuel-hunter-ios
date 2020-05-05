//
//  InlineAlertView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol InlineAlertViewLogic: class {
    func inlineAlertViewFrameChanged()
}

class InlineAlertView: UIView {

	@IBOutlet weak var inlineAlertView: UIView!
	@IBOutlet weak var textLabel: UILabel!
	@IBOutlet weak var heightConstraint: NSLayoutConstraint!

	weak var controller: InlineAlertViewLogic?

	var expanded = false

	// MARK: View lifecycle

	deinit {
		NotificationCenter.default.removeObserver(self, name: .languageWasChanged, object: nil)
		NotificationCenter.default.removeObserver(self, name: .fontSizeWasChanged, object: nil)
	}

	
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

	private func setup() {
		Bundle.main.loadNibNamed("InlineAlertView", owner: self, options: nil)
		addSubview(inlineAlertView)
		inlineAlertView.frame = self.bounds
		expanded = false
		textLabel.text = ""//"inline_alert_default_demo_message".localized()
		NotificationCenter.default.addObserver(self, selector: #selector(languageWasChanged),
    		name: .languageWasChanged, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(fontSizeWasChanged),
    		name: .fontSizeWasChanged, object: nil)
		updateFonts()
  	}

	// MARK: Functions
	
	@IBAction private func inlineAlertWasPressed(_ sender: Any) {
		expanded = false
		UIView.animate(withDuration: 0.3) {
			self.heightConstraint.constant = 0
			self.layoutIfNeeded()
			self.superview?.layoutIfNeeded()
			self.controller?.inlineAlertViewFrameChanged()
		}
	}

	private func updateFonts() {
		textLabel.font = Font(.normal, size: .size6).font
  	}
  	
	// MARK: Notifications

	@objc private func languageWasChanged() {
		textLabel.text = ""//"inline_alert_default_demo_message".localized()
		self.layoutIfNeeded()
		self.superview?.layoutIfNeeded()
	}

	@objc private func fontSizeWasChanged() {
		updateFonts()
		self.heightConstraint.constant = 0
		self.layoutIfNeeded()
		self.superview?.layoutIfNeeded()
	}
}
