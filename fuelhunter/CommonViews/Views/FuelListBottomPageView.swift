//
//  FuelListBottomPageView.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol FuelListBottomPageViewButtonLogic: class {
	func settingsButtonWasPressed()
	func menuButtonWasPressed()
	func pageViewLeftSideWasPressed()
	func pageViewRightSideWasPressed()
}

protocol FuelListBottomPageViewDisplayLogic {
	func setPageCount(_ count: Int, gpsButtonVisible: Bool)
	func setCurrentPage(_ index: Int)
}

class FuelListBottomPageView: UIView, FuelListBottomPageViewDisplayLogic {

	weak var controller: FuelListBottomPageViewButtonLogic?
	@IBOutlet var settingsButton: HIGTargetButton!
	@IBOutlet var customPageControl: CustomPageControl!
	@IBOutlet var menuButton: HIGTargetButton!

	@IBOutlet weak var baseView: UIView!


	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	private func setup() {
		Bundle.main.loadNibNamed("FuelListBottomPageView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true

		settingsButton.translatesAutoresizingMaskIntoConstraints = false
		customPageControl.translatesAutoresizingMaskIntoConstraints = false
		menuButton.translatesAutoresizingMaskIntoConstraints = false

		settingsButton.widthAnchor.constraint(equalToConstant: 23).isActive = true
		settingsButton.heightAnchor.constraint(equalToConstant: 23).isActive = true
		settingsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		settingsButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

		menuButton.widthAnchor.constraint(equalToConstant: 17).isActive = true
		menuButton.heightAnchor.constraint(equalToConstant: 13).isActive = true
		menuButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		menuButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

		customPageControl.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		customPageControl.leftAnchor.constraint(equalTo: settingsButton.rightAnchor, constant: 16).isActive = true
		customPageControl.rightAnchor.constraint(equalTo: menuButton.leftAnchor, constant: -16-6).isActive = true

		settingsButton.addTarget(self, action: NSSelectorFromString("settingsButtonWasPressed"), for: .touchUpInside)
		menuButton.addTarget(self, action: NSSelectorFromString("menuButtonWasPressed"), for: .touchUpInside)
	}

	// MARK: FuelListBottomPageViewDisplayLogic

	func setCurrentPage(_ index: Int) {
		customPageControl.select(index: index)
	}

	func setPageCount(_ count: Int, gpsButtonVisible: Bool) {
		customPageControl.setPageCount(count, gpsButtonVisible: gpsButtonVisible)
	}

	// MARK: Functions

	@objc private func settingsButtonWasPressed() {
		controller?.settingsButtonWasPressed()
	}

	@objc private func menuButtonWasPressed() {
		controller?.menuButtonWasPressed()
	}
}
