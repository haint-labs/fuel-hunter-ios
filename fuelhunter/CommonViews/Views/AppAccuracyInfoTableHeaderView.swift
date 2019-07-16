//
//  AppAccuracyInfoTableHeaderView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AppAccuracyInfoTableHeaderView: UIView {
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var descriptionLabel: UILabel!
	
	override init(frame: CGRect) {
   	super.init(frame: frame)
		setup()
  	}

  	required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
    	setup()
	}

	func setup() {
		Bundle.main.loadNibNamed("AppAccuracyInfoTableHeaderView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		
		self.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		
		descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -25).isActive = true
		
		
		descriptionLabel.text = "Zemāko cenu datus patreiz iegūstam no degvielas kompāniju mājaslapām, tādēļ patreiz šiem datiem ir tikai informatīva nozīme. Turklāt mājaslapā tā informācija netiek atjaunota brīvdienās un svētku dienās.\n\nTomēr, uzskatām, ka jebkurš autobraucējs būs tikai ieguvējs, ja zinās kad kādai degvielas kompānijai krītas degvielas cenas un kur atrast degvielas uzpildes staciju ar lētāko cenu.\n\nPatreiz iegūstam šādus datus:"
		
		descriptionLabel.textColor = UIColor.init(named: "TitleColor")
		descriptionLabel.font = Font.init(.normal, size: .size3).font
  	}
}
