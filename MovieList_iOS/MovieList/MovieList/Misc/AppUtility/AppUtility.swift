//
//  AppUtility.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//

import Foundation
import UIKit

let notificationNameRefresh = "refreshTableData"

class AppUtility: NSObject {
    class func displayAlertController(withVC vc: UIViewController, withAlertStyle alertStyle:UIAlertControllerStyle, withTitle title:String?, withMesssage message:String?, withActions actions:[UIAlertAction]) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: alertStyle)
        for action in actions {
            alert.addAction(action)
        }
        if actions.count < 1 {
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        vc.present(alert, animated: true, completion: nil)
    }
    class func postNotification(_ name:String = notificationNameRefresh) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: name), object: nil)
    }
}
