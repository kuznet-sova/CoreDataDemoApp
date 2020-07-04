//
//  StorageManager.swift
//  CoreDataDemoApp
//
//  Created by Ирина Кузнецова on 30.06.2020.
//  Copyright © 2020 Alexey Efimov. All rights reserved.
//

import CoreData

class StorageManager {
    
    static let shared = StorageManager()
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreDataDemoApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {}
    
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
    
    func deleteContext(_ task: Task) {
        persistentContainer.viewContext.delete(task)
        saveContext()
    }
    
    func fetchData() -> [Task] {
        let fetchRequest: NSFetchRequest<Task> = Task.fetchRequest()
        
        do {
            return try viewContext.fetch(fetchRequest)
        } catch let error {
            print("Failed to fetch data", error)
            return []
        }
    }
    
    func save(_ taskName: String, completion: (Task) -> Void) {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "Task",
            in: persistentContainer.viewContext
            ) else { return }
        
        let task = NSManagedObject(entity: entity, insertInto: viewContext) as! Task
        
        task.name = taskName
        completion(task)
        saveContext()
    }
    
    func edit(_ task: Task, newName: String) {
        task.name = newName
        saveContext()
    }
}
