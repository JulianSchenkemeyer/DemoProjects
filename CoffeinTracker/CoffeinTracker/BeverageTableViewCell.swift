//
//  BeverageTableViewCell.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 26/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class BeverageTableViewCell: UITableViewCell {

    @IBOutlet weak var beverageNameLabel: UILabel!
    @IBOutlet weak var beverageCaffeineLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
