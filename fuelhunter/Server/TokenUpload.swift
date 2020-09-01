//
//  TokenUpload.swift
//  fuelhunter
//
//  Created by Guntis on 09/02/2020.
//  Copyright © 2020 . All rights reserved.
//

import Foundation
import CoreData
import UIKit
import Firebase

protocol TokenUploadLogic: class {
	static func isAllowedToActivate() -> Bool
	static func updateLastSuccessTime()
	static func resetLastSuccessTime()
	func work(completionHandler: @escaping () -> Void)
}

class TokenUpload: TokenUploadLogic {

	static var downloadingState: DownloaderState {
		if DataDownloader.shared.downloaderIsActive {
			return .downloading
		}

		if lastDownloadResult == .none {
			return .downloading
		}
		else
		{
			switch lastDownloadResult {
				case .none:
					return .downloaded
				case .success:
					return .downloaded
				case .timeout:
					return .timeout
				case .serverError:
					return .serverError
				case .parsingError:
					return
						.parsingError
			}
		}
	}

	static var lastDownloadResult: DownloaderLastResult = .none

	class func isAllowedToActivate() -> Bool {

		let lastDownloadTimestamp = UserDefaults.standard.double(forKey: "TokenUploadLastActivateTimestamp")

		if lastDownloadTimestamp == 0 {
			return true
		}

		return false
	}

	class func updateLastSuccessTime() {
		UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "TokenUploadLastActivateTimestamp")
		UserDefaults.standard.synchronize()
	}

	class func resetLastSuccessTime() {
		UserDefaults.standard.set(0, forKey: "TokenUploadLastActivateTimestamp")
		UserDefaults.standard.synchronize()
	}


	func work(completionHandler: @escaping () -> Void) {

		if !TokenUpload.isAllowedToActivate() {
			print("TokenUpload not allowed")
			completionHandler()
			return
		}

		if DataDownloader.shared.downloaderIsActive {
			completionHandler()
			return
		}

		if !AppSettingsWorker.shared.getNotifIsEnabled() {
			// Can't upload, because notif is disabled
			print("TokenUpload not allowed - !AppSettingsWorker.shared.getNotifIsEnabled")
			completionHandler()
			return
		}

		DataDownloader.shared.downloaderIsActive = true

		DispatchQueue.background(background: {
			// do something in background

			let string = "https://robertdemodemo.wixsite.com/mysite/_functions/addToken/"

			print("Token upload string \(string)")

			let sessionConfig = URLSessionConfiguration.default
			sessionConfig.timeoutIntervalForRequest = 10.0
			sessionConfig.timeoutIntervalForResource = 60.0

			let session = URLSession(configuration: sessionConfig)

			var request = URLRequest(url: URL(string: string)!)
			request.httpMethod = "POST"


			let companyFetchRequest: NSFetchRequest<CompanyEntity> = CompanyEntity.fetchRequest()
			companyFetchRequest.predicate = NSPredicate(format: "isEnabled == YES")

			do {
				let existingCompanyList = try DataBaseManager.shared.newBackgroundManagedObjectContext().fetch(companyFetchRequest)

				var companyName = "Neste"

				if existingCompanyList.count == 1 {
					if existingCompanyList.first?.companyMetaData?.company?.name == "Circle K" {
						companyName = "Circle K"
					}
				}

				var paramsDictionary = [String:Any]()
				paramsDictionary["token"] = AppSettingsWorker.shared.getPushNotifToken()
				paramsDictionary["cents"] = NSNumber.init(value: AppSettingsWorker.shared.getStoredNotifCentsCount())
				paramsDictionary["city"] = AppSettingsWorker.shared.getStoredNotifCityName()
				paramsDictionary["company"] = companyName

				print("paramsDictionary \(paramsDictionary)")

				let  jsonData = try? JSONSerialization.data(withJSONObject: paramsDictionary, options: .prettyPrinted)

				request.setValue("application/json", forHTTPHeaderField: "Content-Type")
				request.httpBody = jsonData

				session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in

					if let httpResponse = response as? HTTPURLResponse {
						print("httpResponse.statusCode \(httpResponse.statusCode)")
					}

					// Check if data was received successfully
					if error == nil && data != nil {
						print("TokenUpload - Success")
						TokenUpload.lastDownloadResult = .success
						TokenUpload.updateLastSuccessTime()

					} else {
						print("TokenUpload - Received error OR no data. \(error ?? "" as! Error)")

						if let error = error {

							TokenUpload.resetLastSuccessTime()

							print("(error as NSError).code \((error as NSError).code)")

							Crashlytics.crashlytics().record(error: error)

							if (error as NSError).code == -1009 { // No internet connection
								TokenUpload.lastDownloadResult = .serverError
							} else if (error as NSError).code == -1001 { // Bad connection - timeout
								TokenUpload.lastDownloadResult = .timeout
							} else {
								TokenUpload.lastDownloadResult = .serverError
							}
						} else {
							TokenUpload.lastDownloadResult = .serverError
						}

						if let httpResponse = response as? HTTPURLResponse {
							print("Companies - httpResponse.statusCode \(httpResponse.statusCode)")
						}
					}

					DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
						// when background job finished, do something in main thread
						DataDownloader.shared.downloaderIsActive = false

						completionHandler()
					}

				}.resume()

			} catch let error {
				print("error \(error)")
				Crashlytics.crashlytics().record(error: error)
			}

		}, completion:{
		})
	}
}
