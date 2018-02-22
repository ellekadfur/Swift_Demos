//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


typealias FinishedCompletionHandler = ((String?) -> ())


class HomeViewModel: NSObject {
    
    private var service: Service!
    private var obj: WeatherData?
    
    //MARK: - ViewLifeCycle
    override init() {
        self.service = Service()
        super.init()
    }
    
    //MARK: - Fetch
    func fetchWeatherDataWithBlock(withCompletion completion: @escaping FinishedCompletionHandler) {
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.service.fetchWeatherData(for: "Sunnyvale", completion: { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(objs):
                        strongSelf.obj = objs
                        completion(nil)
                    case let .failure(value):
                        completion(value)
                    }
                }
            })
        }
    }
    
    //MARK: - Access
    func getTitle() -> String {
        if let obj = self.obj, let city = obj.title {
            return city
        }
        return "Error"
    }
    func objectCount() -> NSInteger {
        guard let obj = self.obj, let items = obj.items else { return 0 }
        return items.count
    }
    func objectAtIndex(_ index:NSInteger) -> WeatherDataItem? {
        guard let obj = self.obj, let items = obj.items, index < items.count else { return nil }
        return items[index]
    }
}
