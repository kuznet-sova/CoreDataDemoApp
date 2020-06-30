//
//  StorageManager.swift
//  CoreDataDemoApp
//
//  Created by Ирина Кузнецова on 30.06.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let storageManager = StorageManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
