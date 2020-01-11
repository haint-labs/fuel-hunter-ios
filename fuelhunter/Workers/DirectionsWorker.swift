//
//  DirectionsWorker.swift
//  fuelhunter
//
//  Created by Guntis on 28/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation

class DirectionsWorker: NSObject {

	static let shared = DirectionsWorker()

	/* This should be called when:
		1.) downloaded and stored new addresses
		2.) user location has changed
		3.) just enabled gps
	*/
	func updateDistancesAndDirections() {

		// If it is active, then stop. Downloader should call this, when it's done.
		if DataDownloader.shared.downloaderIsActive {
			return
		}
	}
}
