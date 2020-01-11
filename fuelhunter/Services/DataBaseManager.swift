//
//  DataBaseManager.swift
//  fuelhunter
//
//  Created by Guntis on 28/12/2019.
//  Copyright © 2019 . All rights reserved.
//

import CoreData

class DataBaseManager: NSObject {

	static let shared = DataBaseManager()

	static let PricesEntity = String("PriceEntity")
	static let CompaniesEntity = "CompanyEntity"
	static let AddressesEntity = "AddressEntity"

	var persistentContainer: NSPersistentContainer!

	// MARK: init

	private override init() {
		super.init()

		persistentContainer = NSPersistentContainer(name: "DataBase")
		persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

	}

	// MARK: functions

	func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func saveBackgroundContext(backgroundContext: NSManagedObjectContext) {
		if backgroundContext.hasChanges {
            do {
                try backgroundContext.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }

    func mainManagedObjectContext() -> NSManagedObjectContext {
		return persistentContainer.viewContext
    }

    func newBackgroundManagedObjectContext() -> NSManagedObjectContext {
		return persistentContainer!.newBackgroundContext()
    }
}
