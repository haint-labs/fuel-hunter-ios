//
//  DataDownloader.swift
//  fuelhunter
//
//  Created by Guntis on 28/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import Foundation
import CoreData
import UIKit


protocol DataDownloaderLogic {
	func activateProcess()
	func activateToken()
	func removeToken()
}

class DataDownloader: NSObject, DataDownloaderLogic {

	static let shared = DataDownloader()

	public var companiesDownloader: CompaniesDownloader!
	public var pricesDownloader: PricesDownloader!
	public var tokenUpload: TokenUpload!
	public var tokenRemove: TokenRemove!

	private override init() {
		super.init()

		companiesDownloader = CompaniesDownloader()
		pricesDownloader = PricesDownloader()
		tokenUpload = TokenUpload()
		tokenRemove = TokenRemove()

//		companiesDownloader.resetLastDownloadTime()
//		pricesDownloader.resetLastDownloadTime()
	}

	public var downloaderIsActive: Bool = false {
		didSet {
			DispatchQueue.main.asyncAfter(deadline: .now()) {
				NotificationCenter.default.post(name: .dataDownloaderStateChange, object: nil)
			}
		}
	}

	// MARK: DataDownloaderLogic

	func activateToken() {
		TokenUpload.resetLastSuccessTime()
		self.tokenUpload.work { }
	}

	func removeToken() {
		TokenRemove.resetLastSuccessTime()
		self.tokenRemove.work { }
	}

	func activateProcess() {
		
		if(AppSettingsWorker.shared.getGPSIsEnabled() && AppSettingsWorker.shared.userLocation == nil) {
			print("missing user location. Skip for now");
		}

		if DataDownloader.shared.downloaderIsActive
		{
			print("Downloader is still active. Stopping.")
			return;
		}

		/*
			Basically Two possiblities:
			1.) On first time - start with companies, then prices.
			2.) All other times - start with prices, then companies. If change for companies - do pop up.
		*/

		print("activating process!! Please wait!");


		if CompaniesDownloader.isFirstTime() {

			print("CompaniesDownloader.isFirstTime == true! ");

			print("self.companiesDownloader.work | start ");
			self.companiesDownloader.work
			{
				print("self.companiesDownloader.work | end ");
				// Problem.. No internet? Server problem? No point in continueing...
				if(CompaniesDownloader.downloadingState != .downloaded)
				{
					print("CompaniesDownloader.downloadingState != .downloaded \(CompaniesDownloader.downloadingState)) | Report to Sentry | Stopping.");
					// Report to Sentry
				} else {
					print("self.pricesDownloader.work | start ");
					self.pricesDownloader.work
					{
						print("self.pricesDownloader.work | end ");
						// Problem.. No internet? Server problem? No point in continueing...
						if(PricesDownloader.downloadingState != .downloaded)
						{
							print("PricesDownloader.downloadingState != .downloaded (actually \(PricesDownloader.downloadingState)) | Report to Sentry | Stopping.");
							// Report to Sentry
						} else {
							print("All done!")
							print("Well.. do some token stuff")
							self.tokenUpload.work {
								self.tokenRemove.work { }
							}
						}
					}
				}
			}
		} else {
			print("CompaniesDownloader.isFirstTime == false! ");

			if PricesDownloader.isAllowedToDownload() {
				print("PricesDownloader.isAllowedToDownload() == true! ");

				print("self.pricesDownloader.work | start ");
				self.pricesDownloader.work
				{
					print("self.pricesDownloader.work | end ");
					// Problem.. No internet? Server problem? No point in continueing...
					if(PricesDownloader.downloadingState != .downloaded)
					{
						print("PricesDownloader.downloadingState != .downloaded (actually \(PricesDownloader.downloadingState)) | Report to Sentry | Stopping.");
						// Report to Sentry
					} else {
						print("self.companiesDownloader.work | start ");
						self.companiesDownloader.work
						{
							print("self.companiesDownloader.work | end ");
							if(CompaniesDownloader.downloadingState != .downloaded)
							{
								print("CompaniesDownloader.downloadingState != .downloaded (actually \(CompaniesDownloader.downloadingState)) | Report to Sentry | Stopping.");
								// Report to Sentry
							}
							else {
								print("All done!")
								print("Well.. do some token stuff")
								self.tokenUpload.work {
									self.tokenRemove.work { }
								}
							}
						}
					}
				}
			} else {
				print("PricesDownloader.isAllowedToDownload() == false! ");
				print("Well.. do some token stuff")
				self.tokenUpload.work {
					self.tokenRemove.work { }
				}
			}
		}
	}
}
