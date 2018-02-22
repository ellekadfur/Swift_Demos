//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


struct WeatherData {
    let identifier: String?
    let title: String?
    let items: [WeatherDataItem]?
}

struct WeatherDataItem {
    let imageId: String?
    let tempature: String?
    let dayOfWeek: String?
}




