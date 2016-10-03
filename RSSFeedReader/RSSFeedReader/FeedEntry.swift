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
    
    func saveFeed (url: String) {
        let context = getContext()
        
        let feed = Feed(context: context)
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

//    func getSpecificFeed (feedName: String) -> Feed {
//        let context = getContext()
//        var feed = Feed()
//        
//        let fetchReq: NSFetchRequest<Feed> = NSFetchRequest(entityName: "Feed")
//        let predicate = NSPredicate(format: "feedName == %@", feedName)
//        fetchReq.predicate = predicate
//        
//        do {
//            feed = try context.fetch(fetchReq)
//        }
//        
//        
//        return
//    }
}
