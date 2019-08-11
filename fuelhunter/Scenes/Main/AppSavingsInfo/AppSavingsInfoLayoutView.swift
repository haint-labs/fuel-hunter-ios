//
//  AppSavingsInfoLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AppSavingsInfoLayoutView: UIView, UIScrollViewDelegate {

	@IBOutlet var baseView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var topShadowImageView: UIImageView!
	@IBOutlet weak var bottomShadowImageView: UIImageView!
	var savingsView: AppSavingsView!
	
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
		scrollView.contentSize = CGSize.init(width: scrollView.contentSize.width, height: savingsView.frame.size.height + 30)
		adjustVisibilityOfShadowLines()
	}

	func setup() {
		Bundle.main.loadNibNamed("AppSavingsInfoLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		topShadowImageView.translatesAutoresizingMaskIntoConstraints = false
		bottomShadowImageView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

		topShadowImageView.heightAnchor.constraint(equalToConstant: 3).isActive = true
		topShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		topShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		topShadowImageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true

		bottomShadowImageView.heightAnchor.constraint(equalToConstant: 3).isActive = true
		bottomShadowImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		bottomShadowImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		bottomShadowImageView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 1).isActive = true

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		scrollView.delegate = self
		scrollView.alwaysBounceVertical = true

		setUpView()
  	}

  	func setUpView() {
		savingsView = AppSavingsView.init(frame: CGRect.init(x: 0, y: 10, width: self.frame.width, height: 100))
		scrollView.addSubview(savingsView)
		savingsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
		savingsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
		savingsView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
		savingsView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
	}

	// MARK: Functions

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		adjustVisibilityOfShadowLines()
	}

	func adjustVisibilityOfShadowLines() {
		let alfa = min(50, max(0, scrollView.contentOffset.y))/50.0
		topShadowImageView.alpha = alfa
		let value = scrollView.contentOffset.y+scrollView.frame.size.height-scrollView.contentInset.bottom-scrollView.contentInset.top
		let alfa2 = min(50, max(0, scrollView.contentSize.height-value))/50.0
		bottomShadowImageView.alpha = alfa2
	}
}
