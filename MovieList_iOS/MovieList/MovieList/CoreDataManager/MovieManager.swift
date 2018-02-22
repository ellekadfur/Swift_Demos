//
//  MovieManager.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/19/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit
import CoreData


///Create, Read, Update, Delete
class MovieManager {
    
    private let persistentStoreManager: PersistentStoreManager!
    private var mainContextInstance: NSManagedObjectContext!
    private var ascending = true
    class var sharedInstance: MovieManager {
        struct Singleton {
            static let instance = MovieManager()
        }
        return Singleton.instance
    }
    
    //MARK: - Init
    init() {
        self.persistentStoreManager = PersistentStoreManager.sharedInstance
        self.mainContextInstance = self.persistentStoreManager.getMainContextInstance()
    }
    
    //MARK: - Create
    func saveMovie(_ movie: MovieData) {
        let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainContextInstance
        let movieItem = NSEntityDescription.insertNewObject(forEntityName: EntityType.Movie.rawValue, into: managedObjectContext) as! Movie
        
        movieItem.setValue(movie.identifier, forKey: MovieAttributes.identifier.rawValue)
        movieItem.setValue(movie.date, forKey: MovieAttributes.date.rawValue)
        movieItem.setValue(movie.location, forKey: MovieAttributes.location.rawValue)
        movieItem.setValue(movie.title, forKey: MovieAttributes.title.rawValue)
        
        self.persistentStoreManager.saveWorkerContext(managedObjectContext)
        self.persistentStoreManager.mergeWithMainContext()
        AppUtility.postNotification()
    }
    func saveMovieList(_ movieList: [MovieData], withCompletion completion: @escaping BoolCompletionHandler) {
        DispatchQueue.global().async {
            let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
            managedObjectContext.parent = self.mainContextInstance
            
            for index in 0..<movieList.count {
                let movie = movieList[index]
                let movieItem = NSEntityDescription.insertNewObject(forEntityName: EntityType.Movie.rawValue, into: managedObjectContext) as! Movie
                
                movieItem.setValue(movie.identifier, forKey: MovieAttributes.identifier.rawValue)
                movieItem.setValue(movie.date, forKey: MovieAttributes.date.rawValue)
                movieItem.setValue(movie.location, forKey: MovieAttributes.location.rawValue)
                movieItem.setValue(movie.title, forKey: MovieAttributes.title.rawValue)
                self.persistentStoreManager.saveWorkerContext(managedObjectContext)
            }
            self.persistentStoreManager.mergeWithMainContext()
            DispatchQueue.main.async {
                AppUtility.postNotification()
                completion(true)
            }
        }
    }
    
    //MARK: - Read
    func getMovies(_ sortedByDate: Bool = true, sortAscending: Bool = true) -> [Movie] {
        var fetchedResults: Array<Movie> = Array<Movie>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Movie.rawValue)
        if sortedByDate {
            let sortDescriptor = NSSortDescriptor(key: MovieAttributes.date.rawValue, ascending: sortAscending)
            let sortDescriptors = [sortDescriptor]
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        do {
            fetchedResults = try  self.mainContextInstance.fetch(fetchRequest) as! [Movie]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Movie>()
        }
        
        return fetchedResults
    }
    func getMovieById(_ movieId: String) -> [Movie] {
        var fetchedResults: Array<Movie> = Array<Movie>()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Movie
            .rawValue)
        let findByIdPredicate = NSPredicate(format: "\(MovieAttributes.identifier.rawValue) = %@", movieId)
        fetchRequest.predicate = findByIdPredicate
        
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Movie]
        } catch let fetchError as NSError {
            print("retrieveById error: \(fetchError.localizedDescription)")
            fetchedResults = Array<Movie>()
        }
        
        return fetchedResults
    }
    func getMovies(completion:ItemsCompletionHandler)  {
        // func getMoviesInDateRange(_ sortByDate: Bool = true, sortAscending: Bool = true, startDate: Date = Date(timeInterval:-189216000, since:Date()), endDate: Date = (Calendar.current as NSCalendar).date(byAdding: .day, value: 7, to: Date(), options: NSCalendar.Options(rawValue: 0))!) -> Array<Movie> {
        
        let startDate = Date(timeInterval:-189216000, since:Date())
        let endDate = Date()        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: EntityType.Movie.rawValue)
        let sortDescriptor = NSSortDescriptor(key: MovieAttributes.date.rawValue, ascending: !self.ascending)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        self.ascending = !self.ascending
        let findByDateRangePredicate = NSPredicate(format: "(\(MovieAttributes.date.rawValue) >= %@) AND (\(MovieAttributes.date.rawValue) <= %@)", startDate as CVarArg, endDate as CVarArg)
        fetchRequest.predicate = findByDateRangePredicate
        
        var fetchedResults = Array<Movie>()
        do {
            fetchedResults = try self.mainContextInstance.fetch(fetchRequest) as! [Movie]
        } catch let fetchError as NSError {
            print("retrieveItemsSortedByDateInDateRange error: \(fetchError.localizedDescription)")
        }
        
        completion(fetchedResults)
    }
    
    //MARK: - Update
    func updateMovie(_ movieItem: Movie, movie: MovieData) {
        let managedObjectContext: NSManagedObjectContext = NSManagedObjectContext.init(concurrencyType: NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType)
        managedObjectContext.parent = self.mainContextInstance
        
        movieItem.setValue(movie.identifier, forKey: MovieAttributes.identifier.rawValue)
        movieItem.setValue(movie.date, forKey: MovieAttributes.date.rawValue)
        movieItem.setValue(movie.location, forKey: MovieAttributes.location.rawValue)
        movieItem.setValue(movie.title, forKey: MovieAttributes.title.rawValue)
        
        self.persistentStoreManager.saveWorkerContext(managedObjectContext)
        self.persistentStoreManager.mergeWithMainContext()
        AppUtility.postNotification()
    }
    
    //MARK: - Delete
    func deleteAllMovies() {
        let retrievedItems = getMovies()
        for item in retrievedItems {
            self.mainContextInstance.delete(item)
        }
        self.persistentStoreManager.mergeWithMainContext()
        AppUtility.postNotification()
    }
    func deleteMovie(_ eventItem: Movie) {
        self.mainContextInstance.delete(eventItem)
        AppUtility.postNotification()
    }
}

