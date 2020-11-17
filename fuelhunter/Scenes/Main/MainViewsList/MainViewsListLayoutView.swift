//
//  MainViewsListLayoutView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit
import SDWebImage

protocol MainViewsListLayoutViewLogic: class {
	func settingsButtonPressed()
	func areasListButtonPressed()
}

protocol MainViewsListLayoutViewDataLogic: class {
	func setUpPages(areaNames: [MainViewsList.FetchAreas.ViewModel.DisplayedArea])
}

class MainViewsListLayoutView: UIView, UIScrollViewDelegate, MainViewsListLayoutViewDataLogic, FuelListBottomPageViewButtonLogic {

	weak var navigationController: UINavigationController?

	weak var controller: MainViewsListLayoutViewLogic?

	@IBOutlet var baseView: UIView!
	@IBOutlet weak var scrollView: UIScrollView!

	@IBOutlet var fuelListBottomPageView: FuelListBottomPageView!

	var areas = [MainViewsList.FetchAreas.ViewModel.DisplayedArea]()

	var page1: FuelListViewController!
	var page2: FuelListViewController!
	var page3: FuelListViewController!
	var lastSetUpPage: NewAreaPageViewController!

	var page1LeftConstraint: NSLayoutConstraint!
	var page2LeftConstraint: NSLayoutConstraint!
	var page3LeftConstraint: NSLayoutConstraint!
	var lastPageLeftConstraint: NSLayoutConstraint!


	var page1Index = -1
	var page2Index = -1
	var page3Index = -1

	var currentPageIndex: Int = -1

	// MARK: View lifecycle

	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	deinit {
	}

	override func layoutSubviews() {
		super.layoutSubviews()
	}

	private func setup() {
		Bundle.main.loadNibNamed("MainViewsListLayoutView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds

		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		fuelListBottomPageView.translatesAutoresizingMaskIntoConstraints = false

		scrollView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		scrollView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		scrollView.topAnchor.constraint(equalTo: topAnchor).isActive = true
		scrollView.bottomAnchor.constraint(equalTo: fuelListBottomPageView.topAnchor, constant: -10).isActive = true

		fuelListBottomPageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
		fuelListBottomPageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
		fuelListBottomPageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
		fuelListBottomPageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true

		baseView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
		baseView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true

		scrollView.delegate = self
    	scrollView.backgroundColor = UIColor.clear
		scrollView.isPagingEnabled = true

		scrollView.backgroundColor = .clear
		scrollView.showsHorizontalScrollIndicator = false
    	fuelListBottomPageView.controller = self
  	}

	// MARK: UIScrollViewDelegate

  	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let pageIndex = scrollView.contentOffset.x / self.frame.size.width
		updateToIndex(Int(pageIndex))
	}

	// MARK: Functions

	private func updateToIndex(_ index: Int) {
		if currentPageIndex != index {

			fuelListBottomPageView.setCurrentPage(index)

			if page1Index == -1 { // First time set up
				page1Index = max(0, index - 1)
				page2Index = page1Index + 1
				page3Index = page2Index + 1

				if areas.count > 3 && index > 1 {
					page3Index = min(areas.count - 1, index + 1)
					page2Index = page3Index - 1
					page1Index = page2Index - 1
				}
			} else {
				if currentPageIndex < index && index < areas.count - 1  { // next page
					if (page1Index == index - 2) { page1Index = index + 1 }
					if (page2Index == index - 2) { page2Index = index + 1 }
					if (page3Index == index - 2) { page3Index = index + 1 }
				} else if currentPageIndex > index && index > 0 { // previous page
					if (page1Index == index + 2) { page1Index = index - 1 }
					if (page2Index == index + 2) { page2Index = index - 1 }
					if (page3Index == index + 2) { page3Index = index - 1 }
				}
			}

			currentPageIndex = index
			reorderPages()
		}
	}

	private func setUpBasicsForPageView(_ view: UIView) {
		scrollView.addSubview(view)
		view.translatesAutoresizingMaskIntoConstraints = false
		view.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
		view.bottomAnchor.constraint(equalTo: fuelListBottomPageView.topAnchor, constant: -10).isActive = true
		view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
	}

	private func createPages() {
		page1 = FuelListViewController.init()
		page2 = FuelListViewController.init()
		page3 = FuelListViewController.init()

		page1.router?.navigationController = navigationController
		page2.router?.navigationController = navigationController
		page3.router?.navigationController = navigationController

		lastSetUpPage = NewAreaPageViewController.init()
		lastSetUpPage.router?.navigationController = navigationController
	}

	// MARK: MainViewsListLayoutViewDataLogic

	func setUpPages(areaNames: [MainViewsList.FetchAreas.ViewModel.DisplayedArea]) {
		areas = areaNames
		updateToIndex(0)
		fuelListBottomPageView.setPageCount(areaNames.count + 1, gpsButtonVisible: true)
		self.scrollView.contentSize = CGSize.init(width: CGFloat(self.frame.size.width) * CGFloat(areaNames.count + 1), height: scrollView.frame.size.height)
		self.scrollView.setContentOffset(CGPoint(x: CGFloat(self.frame.size.width) * CGFloat(currentPageIndex), y: 0), animated: false)
	}

	func reorderPages() {

		if(page1 == nil) {
			createPages()

			setUpBasicsForPageView(page1.view)
			setUpBasicsForPageView(page2.view)
			setUpBasicsForPageView(page3.view)
			setUpBasicsForPageView(lastSetUpPage.view)

//			page1.view.backgroundColor = .red
//			page2.view.backgroundColor = .green
//			page3.view.backgroundColor = .blue

			page1LeftConstraint = page1.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0)
			page1LeftConstraint.isActive = true
			page2LeftConstraint = page2.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0)
			page2LeftConstraint.isActive = true
			page3LeftConstraint = page3.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0)
			page3LeftConstraint.isActive = true


			lastPageLeftConstraint = lastSetUpPage.view.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0)
			lastPageLeftConstraint.isActive = true
		}

		page1.view.isHidden = true
		page2.view.isHidden = true
		page3.view.isHidden = true
		lastSetUpPage.view.isHidden = true


		// Presume, always that we have at least 1 page
		if page1.router?.dataStore?.areaName != areas[page1Index].name {
			page1.router?.dataStore?.areaName = areas[page1Index].name
			page1.router?.dataStore?.areaType = areas[page1Index].type
			page1.getForcedData()
			page1.getCityViewData()
		} else {
			page1.scrollToTop()
		}
		page1LeftConstraint.constant = CGFloat(self.frame.size.width) * CGFloat(page1Index)
		page1.view.isHidden = false

		if page2Index <= areas.count-1    {
			if page2.router?.dataStore?.areaName != areas[page2Index].name {
				page2.router?.dataStore?.areaName = areas[page2Index].name
				page2.router?.dataStore?.areaType = areas[page2Index].type
				page2.getForcedData()
				page2.getCityViewData()
			} else {
				page2.scrollToTop()
			}
			page2LeftConstraint.constant = CGFloat(self.frame.size.width) * CGFloat(page2Index)
			page2.view.isHidden = false
		}

		if page3Index <= areas.count-1  {
			if page3.router?.dataStore?.areaName != areas[page3Index].name {
				page3.router?.dataStore?.areaName = areas[page3Index].name
				page3.router?.dataStore?.areaType = areas[page3Index].type
				page3.getForcedData()
				page3.getCityViewData()
			} else {
				page3.scrollToTop()
			}
			page3LeftConstraint.constant = CGFloat(self.frame.size.width) * CGFloat(page3Index)
			page3.view.isHidden = false

		}

		lastPageLeftConstraint.constant = CGFloat(self.frame.size.width) * CGFloat(areas.count)
		lastSetUpPage.view.isHidden = false
	}

	// MARK: FuelListBottomPageViewButtonLogic

	func settingsButtonWasPressed() {
		controller?.settingsButtonPressed()
	}

	func menuButtonWasPressed() {
		controller?.areasListButtonPressed()
	}

	func pageViewLeftSideWasPressed() {
		
	}

	func pageViewRightSideWasPressed() {

	}
}
