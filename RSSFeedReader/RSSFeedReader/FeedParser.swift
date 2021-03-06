//
//  FeedParser.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 26/08/16.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import Foundation
//import CoreData
//import UIKit


class FeedParser: NSObject, XMLParserDelegate {
    
    var eName: String = String()
    var entryTitle: String = String()
    var entryURL: String = String()
    var entryDate: Date = Date()
    var oldEntries: [Item] = []
    
    var currentFeedName: String = ""
    var currentFeedURL: String = ""
    

    
    var parser: XMLParser!
//    var posts = NSMutableArray()
//    var elements = NSMutableDictionary()
//    var element = NSString()
//    var elementTitle =

    
    
    func refreshFeed(feedName: String, feedAddress: String) {
//        let urlString = NSURL(string: feedAddress)
        self.currentFeedURL = feedAddress
        self.currentFeedName = feedName
        let path = URL(string: feedAddress)
//        if let path = NSBundle.mainBundle().URLForResource("Books", withExtension: "xml"){
            if let parser = XMLParser(contentsOf: path!) {
                parser.delegate = self
                parser.parse()
            }
//        }
    
        print("Finished?")
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        
//        print(elementName)
        
        if elementName == "item" {
            entryTitle = String()
            entryURL = String()
            entryDate = Date()
        
            print("START ELEMENT: \(entryTitle) + \(entryURL)")

        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let itemEntry = ItemEntry()
            var isExisting = false
            
            //check if entry already exists
            for oldEntry in oldEntries {
//                var test = oldEntry.itemTitle
                if (oldEntry.itemTitle == entryTitle) {
                    isExisting = true
                }
            }
            
            //get Feed-Object
            let feedEntry = FeedEntry()
            var feedRes: [Feed] = feedEntry.getSpecificFeed(feedURL: self.currentFeedURL)
            if feedRes.count == 0 {
                feedEntry.saveFeed(name: currentFeedName, url: currentFeedURL)
                feedRes = feedEntry.getSpecificFeed(feedURL: self.currentFeedURL)
            }
            let feed = feedRes[0]
            if (!isExisting) {
                itemEntry.saveItem(title: entryTitle, link: entryURL, description: "", pubDate: entryDate, feed: feed)
            }
//            let entry = FeedEntry()
//            entry.title = entryTitle
//            entry.url = entryURL
            
            print("END ELEMENT: \(entryTitle) + \(entryURL)")
            
//            feedEntries.append(entry)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        if (!data.isEmpty) {
            if eName == "title" {
                entryTitle += data
            } else if eName == "link" {
                entryURL += data
            } else if eName == "pubDate" {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss zzz"
                entryDate = dateFormatter.date(from: data)!
            }
        }
    }
}
