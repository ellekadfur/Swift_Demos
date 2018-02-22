//
//  MovieVC.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//

import UIKit
import CoreData

class MovieVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var viewModel: MovieViewModel!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configObjs()
        self.configView()
        self.configNotifications()
        self.configData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: Notification.Name(notificationNameRefresh), object: nil)
    }
    
    //MARK: - Config
    func configNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleRefreshNotitification), name: Notification.Name(notificationNameRefresh), object: nil)
    }
    func configObjs() {
        self.viewModel = MovieViewModel()
    }
    func configView() {
        self.tableView.register(UINib(nibName: MovieCell.name(), bundle: nil), forCellReuseIdentifier: MovieCell.identifier())
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = UIView()
    }
    func configData() {
        self.refreshButton.isUserInteractionEnabled = false
        self.loadingView.isHidden = false
        self.viewModel.fetchMovieDataWithBlock(withCompletion: { (string) in
            if let _ = string  {
                self.loadingView.isHidden = false
                self.refreshButton.isUserInteractionEnabled = true
            }
            else {
                self.refreshButton.isUserInteractionEnabled = false
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK: - Notifications
    @objc func handleRefreshNotitification() {
        self.tableView.reloadData()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.objectCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieCell.identifier(), for: indexPath) as! MovieCell
        cell.configCellWithObj(self.viewModel.objectAtIndex(indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let nav = MapVC.instanceNav() as? UINavigationController {
            if let vc = MapVC.instance() as? MapVC {
                let obj = self.viewModel.objectAtIndex(indexPath.row)
                vc.setSearchString(withLocation: obj.location)
                nav.setViewControllers([vc], animated: false)
                self.present(nav, animated: true, completion:nil)
                return
            }
        }
        AppUtility.displayAlertController(withVC: self, withAlertStyle: UIAlertControllerStyle.alert, withTitle: "Oops", withMesssage: "We couldn't load the map.", withActions:[])
    }
    
    //MARK: - Actions
    @IBAction func onTouchRefresh(_ sender: Any) {
        self.configData()
    }
    @IBAction func onTouchUpdateListSort(_ sender: Any) {
        self.loadingView.isHidden = false
        self.refreshButton.isUserInteractionEnabled = false
        self.viewModel.updateOrder(withCompletion:  { (action) in
            if action {
                self.loadingView.isHidden = true
                self.tableView.reloadData()
            }
        })
    }
}

