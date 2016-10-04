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
    
    var feedEntries: [FeedEntry] = []
    var eName: String = String()
    var entryTitle: String = String()
    var entryURL: String = String()
    var entryDate: Date = Date()
    

    
    var parser: XMLParser!
//    var posts = NSMutableArray()
//    var elements = NSMutableDictionary()
//    var element = NSString()
//    var elementTitle =

    
    
    func refreshFeed(_ feedAddress: String) {
//        let urlString = NSURL(string: feedAddress)
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
            itemEntry.saveItem(title: entryTitle, link: entryURL, description: "", pubDate: entryDate)
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
