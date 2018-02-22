//
//  PerManager.swift
//  MovieList
//
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import Foundation
import CoreData


class PersistentStoreManager: NSObject {

    fileprivate var appDelegate: AppDelegate
    fileprivate var mainContextInstance: NSManagedObjectContext
    class var sharedInstance: PersistentStoreManager {
        struct Singleton {
            static let instance = PersistentStoreManager()
        }
        return Singleton.instance
    }

    //MAKR: - Init
    override init() {
        appDelegate = AppDelegate().sharedInstance()
        mainContextInstance = ManagedObjectContextManager.init().mainManagedObjectContextInstance
        super.init()
    }

    //MARK: - Access
    func getMainContextInstance() -> NSManagedObjectContext {
        return self.mainContextInstance
    }
    
    //MARK: - Save
    func saveWorkerContext(_ workerContext: NSManagedObjectContext) {
        //Persist new Event to datastore (via Managed Object Context Layer).
        do {
            try workerContext.save()
        } catch let saveError as NSError {
            print("save minion worker error: \(saveError.localizedDescription)")
        }
    }

    //MARK: - Merge
    func mergeWithMainContext() {
        do {
            try self.mainContextInstance.save()
        } catch let saveError as NSError {
            print("synWithMainContext error: \(saveError.localizedDescription)")
        }
    }
}
