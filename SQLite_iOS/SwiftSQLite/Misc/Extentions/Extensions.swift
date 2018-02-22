//
//  Extensions.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


//MARK: - UIViewController
extension UIViewController {
    static func name() -> String {
        return String(describing: self)
    }
    static func instance() -> UIViewController? {
            return UIStoryboard(name: self.name().replacingOccurrences(of: "VC", with: ""), bundle: nil).instantiateViewController(withIdentifier : self.name())
    }
    static func instanceNav() -> UIViewController? {
        return UIStoryboard(name: self.name().replacingOccurrences(of: "VC", with: ""), bundle: nil).instantiateViewController(withIdentifier : self.name() + "Nav")
    }
}

//MARK: - UITableViewCell
extension UITableViewCell {
    static func identifier() -> String {
        return String(describing: self) + "Identifier"
    }
}

//MARK: - UIView
extension UIView {
    static func name() -> String {
        return String(describing: self)
    }
}


