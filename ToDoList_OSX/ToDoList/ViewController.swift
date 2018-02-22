//
//  ViewController.swift
//  ToDoList
//
//  Created by Lamar Jay Caaddfiir on 10/3/17.
//  Copyright © 2017 AppNaq, LLC. All rights reserved.
//


import Cocoa


class ViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {

    @IBOutlet weak var delete: NSButton!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var importantCheckbox: NSButton!
    var todoItems: [ToDoItem] = []
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getItems ()
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }

    
    /// Will get ToDoItems from Coredata & update tableview
    func getItems() {
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            do {
                self.todoItems = try context.fetch(ToDoItem.fetchRequest())
                print(todoItems.count)
            } catch {
                
            }
        }
        tableView.reloadData()
        self.delete.isHidden = true
    }
    
    //MARK: - Actions
    @IBAction func buttonTapped(_ sender: Any) {
        if textField.stringValue.isEmpty || textField.stringValue == "" {
            return
        }
        if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
            let todoItem = ToDoItem(context: context)
            todoItem.name = textField.stringValue
            if self.importantCheckbox.state == .off {
                  todoItem.important = false
            }
            else {
                  todoItem.important = true
            }
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            
            //reset values to zero.
            self.textField.stringValue = ""
            self.importantCheckbox.state = .off
            
            self.getItems()
        }
    }
    
    @IBAction func deleteClicked(_ sender: Any) {
        let todoItem = todoItems[tableView.selectedRow]
         if let context = (NSApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext {
         context.delete(todoItem)
            (NSApplication.shared.delegate as? AppDelegate)?.saveAction(nil)
            self.getItems()
        }
    }
    
    //MARK: - NSTableViewDataSource
    func numberOfRows(in tableView: NSTableView) -> Int {
        return self.todoItems.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        if (tableColumn?.identifier)!.rawValue == "importantColumn" {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "importantCell"), owner: self) as? NSTableCellView {
                let todoItem = todoItems[row]
                if todoItem.important {
                    cell.textField?.stringValue = "❗️"
                }
                else {
                    cell.textField?.stringValue = ""
                }
                return cell
            }
        }
        else {
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "nameCell"), owner: self) as? NSTableCellView {
                let todoItem = todoItems[row]
                if let name = todoItem.name {
                    cell.textField?.stringValue = name
                }
                return cell
            }
        }
        return nil
    }
    //MARK: - NSTableViewDelegate
    func tableViewSelectionDidChange(_ notification: Notification) {
        self.delete.isHidden = false
    }
}

