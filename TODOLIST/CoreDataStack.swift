//
//  CoreDataStack.swift
//  TODOLIST
//
//  Created by RAK on 02/03/2019.
//  Copyright © 2019 RAK. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {
    
    static let shared = CoreDataStack()
    var errorHandler: (Error) -> Void = {_ in }
    
    //#1
    lazy var persistentContainer: PersistentContainer = {
        let container = PersistentContainer(name: "TODOLIST")
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                NSLog("CoreData error \(error), \(error._userInfo)")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    //#2
    lazy var viewContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    //#3
    // Optional
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    //#4
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    //#5
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
    
    // CoreData
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

struct CoreDataServiceConsts {
    static let applicationGroupIdentifier = "group.com.rak.dailytodo"
}

final class PersistentContainer: NSPersistentContainer {
    internal override class func defaultDirectoryURL() -> URL {
        var url = super.defaultDirectoryURL()
        if let newURL =
            FileManager.default.containerURL(
                forSecurityApplicationGroupIdentifier: CoreDataServiceConsts.applicationGroupIdentifier) {
            url = newURL
        }
        return url
    }
}
