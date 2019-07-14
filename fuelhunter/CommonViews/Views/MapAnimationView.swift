//
//  MapAnimationView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class MapAnimationView: UIView {
	
	@IBOutlet weak var baseView: UIView!
	
	@IBOutlet weak var mapImageView: UIImageView!
	@IBOutlet weak var topImageView: UIImageView!
	
	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}
	
	func setup() {
		Bundle.main.loadNibNamed("MapAnimationView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		self.layoutIfNeeded()
		
		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		mapImageView.translatesAutoresizingMaskIntoConstraints = false
		topImageView.translatesAutoresizingMaskIntoConstraints = false
		
		mapImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: -250).isActive = true
		mapImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
		mapImageView.widthAnchor.constraint(equalToConstant: (topImageView.image?.size.width)!+250).isActive = true
		mapImageView.heightAnchor.constraint(equalTo: mapImageView.widthAnchor).isActive = true

		topImageView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
		topImageView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
		topImageView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true

		topImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
		
		self.layoutIfNeeded()
		self.clipsToBounds = true
  	}

	//MARK: functions for animating
	
	func startAnimating() {
		self.mapImageView.transform = CGAffineTransform(translationX: -20, y: 0)
		DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
			self.firstMove()
		}
	}
	
	func firstMove() {
		UIView.animate(withDuration: 1.6, delay: 0.7, options: [], animations: {
			self.mapImageView.transform = CGAffineTransform(translationX: 45, y: 130)
		}, completion: { (finished: Bool) in 
			if finished {
				self.secondMove()
			}
		})
	}
	
	func secondMove() {
		UIView.animate(withDuration: 1.6, delay: 0.7, options: [], animations: {
			self.mapImageView.transform = CGAffineTransform(translationX: -30, y: 250)
		}, completion: { (finished: Bool) in 
			if finished {
				self.thirdMove()
			}
		})
	}
	
	func thirdMove() {
		UIView.animate(withDuration: 1.8, delay: 0.7, options: [], animations: {
			self.mapImageView.transform = CGAffineTransform(translationX: -20, y: 0)
		}, completion: { (finished: Bool) in 
			if finished {
				self.firstMove()
			}
		})
	}	
}
