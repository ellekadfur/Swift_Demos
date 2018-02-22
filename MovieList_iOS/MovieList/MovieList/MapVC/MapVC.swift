//
//  MapVC.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//

import UIKit
import MapKit


class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    private var searchString: String!
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateMap(withLocation: "SkyCatch")
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         self.updateMap(withLocation: self.searchString)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - PUblic
    func setSearchString(withLocation location:String) {
        self.searchString = location
    }
    private func updateMap(withLocation location:String) {
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = location
        request.region = mapView.region
        let search = MKLocalSearch(request: request)
        
        search.start(completionHandler: {(response, error) in
            if error != nil {
                print("Error occured in search: \(error!.localizedDescription)")
            } else if response!.mapItems.count == 0 {
                print("No matches found")
            } else {
                print("Matches found")
                for item in response!.mapItems {
                    // print("Name = \(String(describing: item.name))")
                    // print("Phone = \(String(describing: item.phoneNumber))")
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = item.placemark.coordinate
                    annotation.title = item.name
                    self.mapView.addAnnotation(annotation)
                    
                    let regionRadius: CLLocationDistance = 1000
                    let coordinateRegion = MKCoordinateRegionMakeWithDistance(item.placemark.coordinate, regionRadius, regionRadius)
                    self.mapView.setRegion(coordinateRegion, animated: true)
                }
            }
        })
    }
    
    //MARK: - Actions
    @IBAction func onTouchExit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}
