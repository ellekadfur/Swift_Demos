//
//  WeatherHeaderView.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/7/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class WeatherHeaderView: UIView {
    var contentView: WeatherHeaderView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tempatureLabel: UILabel!
    @IBOutlet weak var theContentView: UIView!
    
    //MARK: - ViewLifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
    customInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        customInit()
    }
    
    func customInit() {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        self.theContentView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        self.theContentView.frame = self.bounds
        addSubview(self.theContentView)
    }
    //MARK: - Config
    func configHeaderWithObj(_ item:WeatherDataItem?) {
        guard let theItem = item, let theUrl = theItem.imageId else {
            self.tempatureLabel.text = "Error"
            return
        }
        
        self.tempatureLabel.text = theItem.tempature
        ImageDownloader.fetchImageUrl(for: theUrl, completion: { (result) in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self.imageView.image = image
                    self.imageView.backgroundColor = UIColor.clear
                case let .failure(value):
                    print("Error with Desciption \(value)")
                    self.imageView.backgroundColor = UIColor.gray
                }
            }
        })
    }
}
