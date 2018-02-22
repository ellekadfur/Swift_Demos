//
//  MovieData.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit
import CoreData


struct MovieData {
    var identifier: String
    var title: String
    var date: Date
    var location: String
    
    static func endpoint() -> String {
        return "https://data.sfgov.org/api/views/yitu-d5am/rows.json?accessType=DOWNLOAD"
    }
}

@objc(Movie)
class Movie: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var identifier: String
    @NSManaged var date: Date
    @NSManaged var location: String
}

enum EntityType: String {
    case Movie
    
    static let all = [Movie]
}

enum MovieAttributes: String {
    case title
    case identifier
    case date
    case location
}
