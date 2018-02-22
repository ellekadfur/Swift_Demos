//
//  AppDelegate.swift
//  LinkIt
//
//  Created by Lamar Jay Caaddfiir on 10/3/17.
//  Copyright © 2017 AppNaq, LLC. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var item: NSStatusItem? = nil
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        self.item?.image = NSImage(named:NSImage.Name(rawValue: "link"))
//        self.item?.action = #selector(AppDelegate.linkIt) //overriden by menu
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "LinkIt", action: #selector(AppDelegate.linkIt), keyEquivalent: "l"))
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(AppDelegate.quit), keyEquivalent: "Q"))
        self.item?.menu = menu
 }

    func applicationWillTerminate(_ aNotification: Notification) { }
    
    func printPastboard() {
        if let items = NSPasteboard.general.pasteboardItems {
            for item in items {
                for type in item.types {
                    print("Type:\(type)")
                    print("String:\(String(describing: item.string(forType:type)))")
                }
            }
        }
    }
    //MARK: - Actions
    @objc func linkIt() {
        print("we")
        if let items = NSPasteboard.general.pasteboardItems {
            for item in items {
                for type in item.types {
                    if type.rawValue == "public.utf8-plain-text" {
                        if let url = item.string(forType:type) {
//                         print(url)
//                            printPastboard()
                            var actualUrl = ""
                            if url.hasPrefix("http://") || url.hasPrefix("https://") {
                                actualUrl = url
                            }
                            else {
                                actualUrl = "http://" + url
                            }// testing: www.google.com
                            NSPasteboard.general.clearContents()
                            NSPasteboard.general.setString(url, forType: .string)
                            NSPasteboard.general.setString("<a href=\"http://\(actualUrl)\">\(url)</a>", forType: .html)
//                            printPastboard()

                        }
                    }
                }
            }
        }
        printPastboard()
    }
    
    @objc func quit() {
        NSApplication.shared.terminate(self)
    }
}

