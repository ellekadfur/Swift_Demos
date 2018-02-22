//
//  MovieViewModel.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit
import CoreData

typealias FinishedCompletionHandler = ((String?) -> ())
typealias BoolCompletionHandler = ((Bool) -> ())
typealias ItemsCompletionHandler = (([Movie]) -> ())


class MovieViewModel: NSObject {
    private var service: Service!
    private var objs: [Movie]
    
    //MARK: - ViewLifeCycle
    override init() {
        self.service = Service()
        self.objs = []
        super.init()
    }
    
    //MARK: - Fetch
    func fetchMovieDataWithBlock(withCompletion completion: @escaping FinishedCompletionHandler) {
        DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
            guard let strongSelf = self else { return }
            strongSelf.service.fetchMovieData(completion: { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case let .success(objs):
                        MovieManager.sharedInstance.saveMovieList(objs, withCompletion: {(action) in
                            if action {
                                strongSelf.objs = MovieManager.sharedInstance.getMovies()
                                completion(nil)
                            }
                        })
                    case let .failure(value):
                        completion(value)
                    }
                }
            })
        }
    }
    
    //MARK: - Access
    func objectCount() -> NSInteger {
        return objs.count
    }
    func objectAtIndex(_ index:NSInteger) -> Movie {
        return objs[index]
    }
    func updateOrder(withCompletion completion:BoolCompletionHandler) {
        MovieManager.sharedInstance.getMovies(completion: { (objs) in
             self.objs = objs
                completion(true)
        })
    }
}
