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
    
    func saveItem (title: String, link: String, description: String) {
        let context = getContext()
        
        let item = Item(context: context)
        item.itemTitle = title
        item.itemLink = link
        item.itemDescription = description
        item.itemIsRead = false
        
        
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
            items = try context.fetch(Item.fetchRequest())
        } catch {
            print("Fetch failed")
        }
        
        return items
    }
}
