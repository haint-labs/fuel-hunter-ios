//
//  AppSavingsView.swift
//  fuelhunter
//
//  Created by Guntis on 05/06/2019.
//  Copyright © 2019 . All rights reserved.
//

import UIKit

class AppSavingsView: UIView {
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var savingsIcon1: UIImageView!
	@IBOutlet weak var savingsIcon2: UIImageView!
	@IBOutlet weak var savingsIcon3: UIImageView!
	@IBOutlet weak var savingsIcon4: UIImageView!
	@IBOutlet weak var savingsLabel1: UILabel!
	@IBOutlet weak var savingsLabel2: UILabel!
	@IBOutlet weak var savingsLabel3: UILabel!
	@IBOutlet weak var savingsLabel4: UILabel!
	@IBOutlet weak var separatorView: UIView!
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
		Bundle.main.loadNibNamed("AppSavingsView", owner: self, options: nil)
		addSubview(baseView)
		baseView.frame = self.bounds
		baseView.backgroundColor = .blue
		self.translatesAutoresizingMaskIntoConstraints = false
		baseView.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon1.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon2.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon3.translatesAutoresizingMaskIntoConstraints = false
		savingsIcon4.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel1.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel2.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel3.translatesAutoresizingMaskIntoConstraints = false
		savingsLabel4.translatesAutoresizingMaskIntoConstraints = false
		separatorView.translatesAutoresizingMaskIntoConstraints = false
		descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
		
		savingsIcon1.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon1.heightAnchor.constraint(equalTo: savingsIcon1.widthAnchor).isActive = true
		savingsIcon1.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
		savingsIcon1.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel1.leftAnchor.constraint(equalTo: savingsIcon1.rightAnchor, constant: 16).isActive = true
		savingsLabel1.topAnchor.constraint(equalTo: topAnchor).isActive = true
		savingsLabel1.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		
		savingsIcon2.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon2.heightAnchor.constraint(equalTo: savingsIcon2.widthAnchor).isActive = true
		savingsIcon2.topAnchor.constraint(equalTo: savingsLabel1.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon2.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel2.leftAnchor.constraint(equalTo: savingsIcon2.rightAnchor, constant: 16).isActive = true
		savingsLabel2.topAnchor.constraint(equalTo: savingsLabel1.bottomAnchor, constant: 16).isActive = true
		savingsLabel2.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		
		savingsIcon3.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon3.heightAnchor.constraint(equalTo: savingsIcon3.widthAnchor).isActive = true
		savingsIcon3.topAnchor.constraint(equalTo: savingsLabel2.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon3.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel3.leftAnchor.constraint(equalTo: savingsIcon3.rightAnchor, constant: 16).isActive = true
		savingsLabel3.topAnchor.constraint(equalTo: savingsLabel2.bottomAnchor, constant: 16).isActive = true
		savingsLabel3.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		
		savingsIcon4.widthAnchor.constraint(equalToConstant: 26).isActive = true
		savingsIcon4.heightAnchor.constraint(equalTo: savingsIcon4.widthAnchor).isActive = true
		savingsIcon4.topAnchor.constraint(equalTo: savingsLabel3.bottomAnchor, constant: 16+5).isActive = true
		savingsIcon4.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		savingsLabel4.leftAnchor.constraint(equalTo: savingsIcon4.rightAnchor, constant: 16).isActive = true
		savingsLabel4.topAnchor.constraint(equalTo: savingsLabel3.bottomAnchor, constant: 16).isActive = true
		savingsLabel4.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		
		
		separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
		separatorView.topAnchor.constraint(equalTo: savingsLabel4.bottomAnchor, constant: 30).isActive = true
		separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		
		descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
		descriptionLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 30).isActive = true
		descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
		
		
		descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
		
		savingsLabel1.font = Font.init(.normal, size: .size3).font
		savingsLabel2.font = Font.init(.normal, size: .size3).font
		savingsLabel3.font = Font.init(.normal, size: .size3).font
		savingsLabel4.font = Font.init(.normal, size: .size3).font
		descriptionLabel.font = Font.init(.normal, size: .size3).font
		
		savingsLabel1.text = "Parasts autobraucējs, uzpildās degvielas uzpildes stacijā, kas viņam ir pa ceļam starp mājām un darbu, un brīdī kad bāka ir gandrīz tukša."
		savingsLabel2.text = "Lietojot šo aplikāciju, autobraucējs uzzinās par kādu, iespējams, netālu uzpildes staciju, kur cena ir lētāka par 1-5 centiem, nekā stacijā, kur pirms tam uzpildījās."
		savingsLabel3.text = "Turklāt, uzzinot kad tieši nokrītas cenas, autobraucējs var uzpildīt auto īstajā brīdī, tādējādi ilgtermiņā ietaupot vēl vairāk."
		savingsLabel4.text = "Pat ja Jūs braucat uzpildīties kādā citā stacijā, kur cena ir augstāka, vismaz spēsiet novērtēt cenu - vai tā ir pieņemama, vai neadekvāti augsta."
		descriptionLabel.text = """
		Kā piemēru par ietaupījumu, varu minēt savu novērojumu. 

		Uzpildos Neste, kas man bija pa ceļam uz darbu. Tur cena, salīdzinājumā ar lētāko cenu, pārsvarā vienmēr ir par kādiem ~5 centiem dārgāka. Ja es tā vietā uzpildītos lētākajā stacijā, Rīgā, un man būtu bākā vismaz 40 litri brīvi, tad ietaupījums sanāk ~ 2 eur! 

		Mēnesī, braukājot gan uz darbu (15 km dienā), gan citreiz ārpus pilsētas, sanāk dažreiz pat 2 bākas nobraukt. Tātad mēnesī šādā veidā varētu pat ~ 4 eur ietaupīt.

		Gadā tas jau sanāk pie 48 eur - Tā jau ir viena bezmaksas pilna bāka!

		(Ņemiet vērā, ka tas ir labākais gadījums. Varbūt ka Jūs jau dzīvojat vietā, kur pa ceļam ir tā lētākā stacija.. Tad nekāds ietaupījums nesanāks, jo Jūs jau tāpat lēti uzpildījāties. Bet klāt nāks apziņa, ka bijāt viens no tiem, kas uzpildījās lētāk!)

		Ja Jums tas liekas smieklīgi, skaitīt centus, un gada griezumā ietaupīt līdz pat 48 eur, tad vismaz Jūs varat justies labāk, apzinoties ka nav jēga medīt lētāko degvielu, ja tāpat nekāds “jēdzīgs ietaupījums” tas nav!
		"""
  	}
}
