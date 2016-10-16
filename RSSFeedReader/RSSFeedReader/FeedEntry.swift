//
//  FeedEntry.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 03/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import CoreData

class FeedEntry: NSObject {

    func getContext() -> NSManagedObjectContext {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    func saveFeed (name: String, url: String) {
        let context = getContext()
        
        let feed = Feed(context: context)
        feed.feedName = name
        feed.feedURL = url
        
        
        do {
            try context.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }
    
    func getFeeds () -> [Feed] {
        let context = getContext()
        var feeds: [Feed] = []
        
        do {
            feeds = try context.fetch(Feed.fetchRequest())
        } catch {
            print("Fetch failed")
        }
        
        return feeds
    }

    func getSpecificFeed (feedURL: String) -> [Feed] {
        let context = getContext()
        var feed: [Feed] = []
        
//        let fetchReq: NSFetchRequest<Feed> = NSFetchRequest(entityName: "Feed")
//        let predicate = NSPredicate(format: "feedName == %@", feedName)
//        fetchReq.predicate = predicate
        
        do {
            let req: NSFetchRequest<Feed> = NSFetchRequest(entityName: "Feed")
            req.predicate = NSPredicate(format: "feedURL == %@", feedURL)
            //            items = try context.fetch(Item.fetchRequest())
            feed = try context.fetch(req)
            
//            for item in items {
//                item.itemIsRead = true
//                item.itemTitle = item.itemTitle! + "1"
//            }
            
            //            try context.save()
            
        } catch {
            print("Fetch failed")
        }
        
        
        return feed
    }
}
