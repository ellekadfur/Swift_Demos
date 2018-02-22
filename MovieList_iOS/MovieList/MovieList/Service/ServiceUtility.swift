//
//  ServiceUtility.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class ServiceUtility: NSObject {
    class func convertToMovieData(_ dictionary:[String: AnyObject]) -> [MovieData] {
        let dataArray = dictionary[ServiceKeys.data.rawValue] as? [[AnyObject]] ?? []
        var items: [MovieData] = []
        
        for theDataArray in dataArray {
            var index = 0
            var date: Date!
            var location: String!
            var title: String!
            var identifier: String!
            
            for data in theDataArray {
                switch index {
                case PositionKeys.date.rawValue:
                    let theData = data as? String ?? ""
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy"
                    let theDate = formatter.date(from: theData) ?? Date()
                    // print("ljc - dateString:\(dateString)")
                    // print("ljc Time:\(data/1000)")
                    date = theDate
                    break
                case PositionKeys.title.rawValue:
                    let data = data as? String ?? ""
                    title = data
                    break
                case PositionKeys.location.rawValue:
                    let data = data as? String ?? ""
                    location = data
                    break
                case PositionKeys.identifier.rawValue:
                    let data = data as? String ?? ""
                    identifier = data
                    break
                default:
                    break;
                }
                
                index += 1
            
            }
            if items.count == 100 {// would need to set up pagination to remove this.
                break;
            }
            items.append(MovieData(identifier: identifier, title: title, date: date, location: location))
        }
        return items
    }
}
