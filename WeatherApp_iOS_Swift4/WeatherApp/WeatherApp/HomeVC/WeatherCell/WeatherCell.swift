//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Lamar Jay Caaddfiir on 2/7/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class WeatherCell: UITableViewCell {
    
    @IBOutlet weak var imageViewWeather: UIImageView!
    @IBOutlet weak var dayOfWeek: UILabel!
    @IBOutlet weak var tempatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    //MARK: - Config
    func configCellWithObj(_ obj:WeatherDataItem?) {
        guard let theObj = obj else { return }

        self.dayOfWeek.text = theObj.dayOfWeek
        self.tempatureLabel.text = theObj.tempature
        self.fetchImageUrl(theObj.imageId)
    }
    
    
    func fetchImageUrl(_ imageId:String?) {
        guard let theUrl = imageId else { return }
        ImageDownloader.fetchImageUrl(for: theUrl, completion: { (result) in
            DispatchQueue.main.async {
                switch result {
                case let .success(image):
                    self.imageViewWeather.image = image
                    self.imageViewWeather.backgroundColor = UIColor.clear

                case let .failure(value):
                    print("Error with Desciption \(value)")
                    self.imageViewWeather.backgroundColor = UIColor.gray
                }
            }
        })
    }
    
}
