//
//  DevCell.swift
//  SwiftSQLite
//
//  Created by Lamar Jay Caaddfiir on 2/19/18.
//  Copyright © 2018 Lamar Jay Caaddfiir. All rights reserved.
//


import UIKit

let CellIdentifier = "DevCellIdentifier"

class DevCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    
    //MARK: - ViewLifeCycle
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //MARK: - Config
    func configCell(withObj obj:Dev)  {
        self.nameLabel.text = obj.name
        self.ageLabel.text = "\(obj.age)"
    }
}
