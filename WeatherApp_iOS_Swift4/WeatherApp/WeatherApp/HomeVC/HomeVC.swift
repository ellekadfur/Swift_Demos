//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/6/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class HomeVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    private var viewModel: HomeViewModel!
    private var headerView: WeatherHeaderView!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configObjs()
        self.configView()
        self.configData()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Config
    func configObjs() {
        self.viewModel = HomeViewModel()
        self.activityIndicator.hidesWhenStopped = true
        self.headerView = WeatherHeaderView.init(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 150))
    }
    func configView() {
        self.tableView.register(UINib(nibName: WeatherCell.name(), bundle: nil), forCellReuseIdentifier: WeatherCell.identifier())
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = self.headerView
    }
    func configData() {
        self.activityIndicator.startAnimating()
        self.activityIndicator.isHidden = false
        self.stackView.isHidden = false
        self.tableView.isHidden = true
        self.viewModel.fetchWeatherDataWithBlock(withCompletion: { (string) in
            if let string = string  {
                self.loadingLabel.text = string
                self.stackView.isHidden = false
                self.tableView.isHidden = true
                self.activityIndicator.isHidden = true
            }
            else {
                self.title = self.viewModel.getTitle()
                self.tableView.reloadData()
                self.stackView.isHidden = true
                self.tableView.isHidden = false
                if self.viewModel.objectCount() > 0, let obj = self.viewModel.objectAtIndex(0) {
                    self.headerView.configHeaderWithObj(obj)
                }
                else {
                    self.headerView.configHeaderWithObj(nil)
                }
            }
        })
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.objectCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.identifier(), for: indexPath) as! WeatherCell
        cell.selectionStyle = .none
        cell.configCellWithObj(self.viewModel.objectAtIndex(indexPath.row))
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let obj = self.viewModel.getObj() {
            WeatherData.printJson(obj)
        }
    }
}
