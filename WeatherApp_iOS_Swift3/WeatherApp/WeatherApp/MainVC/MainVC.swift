//
//  MainVC.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


/// It's always a good idea to wrap your application in a container View Controller (MainVC)
class MainVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Config
    func configView() {
        if let homeVC = HomeVC.instanceNav() {
            self.addChildViewController(homeVC)
            homeVC.view.frame = self.view.frame
            self.view.addSubview(homeVC.view)
            homeVC.didMove(toParentViewController: self)
        }
    }
}

