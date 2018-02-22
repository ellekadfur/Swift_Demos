//
//  MainVC.swift
//  SwiftXMLParser
//
//  Created by Lamar Jay Caaddfiir on 2/19/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UITableViewDataSource, UITableViewDelegate, XMLParserDelegate {

    private var books: [Book] = []
    private var eName: String = String()
    private var bookTitle = String()
    private var bookAuthor = String()
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configView()
        self.configData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    //MARK: - Config
    func configData() {
        if let path = Bundle.main.url(forResource: "books", withExtension: "xml") {
            if let parser = XMLParser(contentsOf: path) {
                parser.delegate = self
                parser.parse()
            }
        }
    }
    func configView() {
        self.tableView.register(UINib(nibName: BookCell.name(), bundle: nil), forCellReuseIdentifier: BookCell.identifier())
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
    }
    //MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BookCell.identifier(), for: indexPath as IndexPath) as! BookCell
        let book = books[indexPath.row]
        cell.textLabel?.text = book.bookTitle
        cell.detailTextLabel?.text = book.bookAuthor
        return cell
    }
    
    //MARK: - UITableViewDelegate
    
    //MARK: - XMLParserDelegate
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        if elementName == "book" {
            bookTitle = String()
            bookAuthor = String()
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "book" {
            let book = Book()
            book.bookTitle = bookTitle
            book.bookAuthor = bookAuthor
            books.append(book)
        }
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        if (!data.isEmpty) {
            if eName == "title" {
                bookTitle += data
            } else if eName == "author" {
                bookAuthor += data
            }
        }
    }
}

