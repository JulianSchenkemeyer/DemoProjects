//
//  FeedEntry.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 27/08/16.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import Foundation
import CoreData


class OldFeedEntry {
    var title: String = ""
    var url: String = ""
    var description: String = ""
    
    
    
//    func getContext () -> NSManagedObjectContext {
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        return appDelegate.persistentContainer.viewContext
//    }
    
    func saveFeedEntry (context: NSManagedObjectContext) {
        let item = Item(context: context)
        
        item.itemTitle = title
        item.itemLink = url
        item.itemDescription = description
        item.itemIsRead = false
        
        do {
            try context.save()
        } catch let error as Error {
            print("Could not save \(error)")
        }
    }
    
    func getFeedEntries (context: NSManagedObjectContext) -> [FeedEntry] {
        var entries: [FeedEntry] = []
        
        return entries
    }
    
    func checkIfAlreadyExists() {
        
    }
}

