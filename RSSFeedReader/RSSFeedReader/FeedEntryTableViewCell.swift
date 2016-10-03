//
//  FeedEntryTableViewCell.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 27/08/16.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class FeedEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var entryTitleLabel: UILabel!
    
    
    func getContext() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
}
