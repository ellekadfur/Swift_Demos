//
//  ServiceKeys.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


enum ServiceKeys : String {
    case data
}

enum PositionKeys : Int {
    case identifier = 0
    case date = 9
    case title = 8
    case location = 10
}

/*
 Example json
    0
    "E832AF7F-E37B-48E4-8C35-FCDBB9582914",
    0,
    1509143469,
    "881420",
    1509143469,
    "881420",
    null,
    "180",//8 name
    "2011",// 9 date
    "Epic Roasthouse (399 Embarcadero)",//10 location
    null,
    "SPI Cinemas",
    null,
    "Jayendra",
    "Umarji Anuradha, Jayendra, Aarthi Sriram, & Suba ",
    "Siddarth",
    "Nithya Menon",
    "Priya Anand"
*/
