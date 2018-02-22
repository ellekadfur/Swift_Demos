//
//  ManagedObjectContextManager.swift
//  MovieList
//
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import Foundation
import CoreData


class ManagedObjectContextManager: NSObject {

    let coreDataManager: CoreDataManager!
    lazy var masterManagedObjectContextInstance: NSManagedObjectContext = {
        var masterManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        masterManagedObjectContext.persistentStoreCoordinator = self.coreDataManager.persistentStoreCoordinator
        return masterManagedObjectContext
    }()
    lazy var mainManagedObjectContextInstance: NSManagedObjectContext = {
        var mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = self.coreDataManager.persistentStoreCoordinator
        return mainManagedObjectContext
    }()
    
    //MARK: - Init
    override init() {
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        self.coreDataManager = appDelegate.coreDataManager
        super.init()
    }

    //MARK: - Save
    func saveContext() {
        defer {
            do {
                try masterManagedObjectContextInstance.save()
            } catch let masterMocSaveError as NSError {
                print("Master Managed Object Context save error: \(masterMocSaveError.localizedDescription)")
            } catch {
                print("Master Managed Object Context save error.")
            }
        }
        if mainManagedObjectContextInstance.hasChanges {
            mergeChangesFromMainContext()
        }
    }

    //MARK: - Merge
    fileprivate func mergeChangesFromMainContext() {
        DispatchQueue.main.async(execute: {
            do {
                try self.mainManagedObjectContextInstance.save()
            } catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }
}
