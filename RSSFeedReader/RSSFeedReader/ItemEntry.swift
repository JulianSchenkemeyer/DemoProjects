//
//  Itementry.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 03/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import CoreData

class ItemEntry: NSObject {
    
    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveItem (title: String, link: String, description: String, pubDate: Date, feed: Feed) {
        let context = getContext()
        
        let item = Item(context: context)
        item.itemTitle = title
        item.itemLink = link
        item.itemDescription = description
        item.itemPubDate = pubDate as NSDate?
        item.itemIsRead = false
        item.partOf = feed
        
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    
    }
    
    func getItems () -> [Item] {
        let context = getContext()
        var items: [Item] = []
        
        do {
//            let req: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
//            req.predicate = NSPredicate(format: "itemTitle == %@", "Under the Radar: Code Reuse")
            items = try context.fetch(Item.fetchRequest())
//            items = try context.fetch(req)
        } catch {
            print("Fetch failed")
        }
        
        return items
    }
    
    func readItem (itemName: String) {
        let context = getContext()
        var items: [Item] = []
        
        do {
            let req: NSFetchRequest<Item> = NSFetchRequest(entityName: "Item")
            req.predicate = NSPredicate(format: "itemTitle == %@", itemName)
            //            items = try context.fetch(Item.fetchRequest())
            items = try context.fetch(req)
            
            for item in items {
                item.itemIsRead = true
                item.itemTitle = item.itemTitle! + "1"
            }
            
//            try context.save()
            
        } catch {
            print("Fetch failed")
        }
    }
}
