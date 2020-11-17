//
//  CustomTopNamePageControl.swift
//  fuelhunter
//
//  Created by Guntis on 01/09/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

protocol CustomTopNamePageControlButtonLogic: class {
	func customTopNamePageViewLeftSideWasPressed()
	func customTopNamePageViewRightSideWasPressed()
}

protocol CustomTopNamePageControlDisplayLogic {
	func setPageNamesArray(displayedAreas: [MainViewsList.FetchAreas.ViewModel.DisplayedArea])
}

class CustomTopNamePageControl: UIView, CustomTopNamePageControlDisplayLogic, UIScrollViewDelegate {

	weak var controller: CustomTopNamePageControlButtonLogic?
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet var leftButton: UIButton!
	@IBOutlet var rightButton: UIButton!
	@IBOutlet var scrollView: UIScrollView!

	var pages: [ClosestCityNameButtonView] = []


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
		Bundle.main.loadNibNamed("CustomTopNamePageControl", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.clipsToBounds = true

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		leftButton.translatesAutoresizingMaskIntoConstraints = false
		rightButton.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
		self.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		self.heightAnchor.constraint(equalTo: heightAnchor).isActive = true


		leftButton.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		leftButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		leftButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		leftButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true

		rightButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		rightButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
		rightButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		rightButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true

		scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		scrollView.leftAnchor.constraint(equalTo: leftAnchor, constant: 110).isActive = true
		scrollView.rightAnchor.constraint(equalTo: rightAnchor, constant: -110).isActive = true

		scrollView.alwaysBounceHorizontal = false
		scrollView.alwaysBounceVertical = false
		scrollView.showsHorizontalScrollIndicator = false
		scrollView.showsVerticalScrollIndicator = false
		scrollView.isPagingEnabled = true

		scrollView.isScrollEnabled = true
//		scrollView.flashScrollIndicators()
		scrollView.delegate = self
		scrollView.clipsToBounds = false

		leftButton.isHidden = true
		rightButton.isHidden = true
		leftButton.isUserInteractionEnabled = false
		rightButton.isUserInteractionEnabled = false

//		self.scrollView.contentSize = CGSize.init(width: 3000, height: 3000)

	}

	func scrollViewDidScroll(_ scrollView: UIScrollView) {
  		print("scrollview offfset \(scrollView.contentOffset.x)")
	}


	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width
//		fuelListBottomPageView.setCurrentPage(Int(pageIndex))

		var count = 0

		for page in pages {
			if count == Int(pageIndex) {
				page.alpha = 1
			} else {
				page.alpha = 0.5
			}

			count += 1
		}
	}

	func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
		if decelerate { return }

		let pageIndex = scrollView.contentOffset.x / scrollView.frame.size.width

		var count = 0

		for page in pages {
			if count == Int(pageIndex) {
				page.alpha = 1
			} else {
				page.alpha = 0.5
			}

			count += 1
		}

//		fuelListBottomPageView.setCurrentPage(Int(pageIndex))
	}


	// MARK: CustomTopNamePageControlDisplayLogic

	func setPageNamesArray(displayedAreas: [MainViewsList.FetchAreas.ViewModel.DisplayedArea]) {

		self.scrollView.contentSize = CGSize.init(width: CGFloat(self.scrollView.frame.size.width) * CGFloat(displayedAreas.count), height: self.scrollView.frame.size.height)

		for page in pages {
			page.removeConstraints(page.constraints)
			page.removeFromSuperview()
		}

		for n in 0..<displayedAreas.count {
			var page: ClosestCityNameButtonView!
			if pages.count-1 >= n {
				page = pages[n]
			} else {
				page = ClosestCityNameButtonView.init()
				pages.append(page)

				page.isUserInteractionEnabled = false
			}

			scrollView.addSubview(page)
			_ = page.setCity(name: displayedAreas[n].name, gpsIconVisible: (displayedAreas[n].type == .areaTypeGPS))
		}

//		var previousPage: ClosestCityNameButtonView?

		print("pages \(pages)")

		var offset: CGFloat = 0

		for page in pages {
			page.translatesAutoresizingMaskIntoConstraints = false
			page.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
			page.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

//			if let previousPage = previousPage {
				page.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor, constant: offset).isActive = true
//			} else {
//				page.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
//			}
//			if let previousPage = previousPage {
//
//				page.leftAnchor.constraint(equalTo: previousPage.rightAnchor).isActive = true
//			} else {
//				page.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
//			}
//			page.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true

//			previousPage = page

			offset += scrollView.frame.size.width
		}
	}

	// MARK: Functions

	@objc private func customTopNamePageViewLeftSideWasPressed() {
		controller?.customTopNamePageViewLeftSideWasPressed()
	}

	@objc private func customTopNamePageViewRightSideWasPressed() {
		controller?.customTopNamePageViewRightSideWasPressed()
	}
}
