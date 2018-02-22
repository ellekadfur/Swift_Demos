//
//  MainVC.swift
//  SwiftSQLite
//
//  Created by Lamar Jay Caaddfiir on 2/19/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit
import SQLite3

let DBNAME = "Devs"

class MainVC: UIViewController,  UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    private var devList = [Dev]()
    private var db: OpaquePointer? // pointer obj for the sqlite database
    
    //MAKR: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configSQLite()
        self.configView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Config
    func configSQLite() {
        do {
            //create Sqlite file
            let fileURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("DevsDatabase.sqlite")
            
            //open the database
            if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
                print("error opening database")
            }
            
            //create the table
            if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS \(DBNAME) (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER)", nil, nil, nil) != SQLITE_OK {
                let errmsg = String(cString: sqlite3_errmsg(db)!)
                print("error creating table: \(errmsg)")
            }
        }
        catch {
            print("Error opening SQL lite")
        }
    }
    func configView() {
        self.tableView.register(UINib(nibName: DevCell.name(), bundle: nil), forCellReuseIdentifier: DevCell.identifier())
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DevCell.identifier(), for: indexPath) as! DevCell
        cell.configCell(withObj: devList[indexPath.row])
        return cell
    }
    
    //MARK: - UITableViewDelegate

    //MARK: - Actions
    @IBAction func onTouchSave(_ sender:UIButton) {//Should move functionality to own class/file
        let name = nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let age = ageTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let text = name, text.isEmpty {
            nameTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        if let text = age, text.isEmpty {
            ageTextField.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        var stmt: OpaquePointer?//creating a statement
        let queryString = "INSERT INTO \(DBNAME) (name, age) VALUES (?,?)"//the insert query
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, name, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_int(stmt, 2, (age! as NSString).intValue) != SQLITE_OK {//must be NSString
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure binding name: \(errmsg)")
            return
        }
        
        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("failure inserting hero: \(errmsg)")
            return
        }
        
        nameTextField.text = ""
        ageTextField.text = ""
        readValues()        
        print("Devs saved successfully")
    }
    
    //MARK: - Read
    func readValues() {//Should move functionality to own class/file
        //first empty the list of heroes
        devList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM \(DBNAME)"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while (sqlite3_step(stmt) == SQLITE_ROW) {
            let id = sqlite3_column_int(stmt, 0)
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let age = sqlite3_column_int(stmt, 2)
            
            //adding values to list
            devList.append(Dev(id: Int(id), name: String(describing: name), age: Int(age)))
        }
        self.tableView.reloadData()
    }
}

