//
//  MovieCell.swift
//  MovieList
//
//  Created by Lamar Jay Caaddfiir on 2/18/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit


class MovieCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    //MARK: - ViewLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
 
    //MARK: - Config
    func configCellWithObj(_ obj: Movie) {
        self.titleLabel.text = obj.title
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        self.dateLabel.text = formatter.string(from: obj.date)
        self.locationLabel.text = obj.location
    }
}
