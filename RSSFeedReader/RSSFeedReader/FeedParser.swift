//
//  FeedParser.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 26/08/16.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import Foundation


class FeedParser: NSObject, NSXMLParserDelegate {
    
    var feedEntries: [FeedEntry] = []
    var eName: String = String()
    var entryTitle: String = String()
    var entryURL: String = String()
    
    
    
    var parser: NSXMLParser!
//    var posts = NSMutableArray()
//    var elements = NSMutableDictionary()
//    var element = NSString()
//    var elementTitle =
    
    func refreshFeed(feedAddress: String) -> [FeedEntry] {
//        let urlString = NSURL(string: feedAddress)
        let path = NSURL(string: "https://marco.org/rss2")
//        if let path = NSBundle.mainBundle().URLForResource("Books", withExtension: "xml"){
            if let parser = NSXMLParser(contentsOfURL: path!) {
                parser.delegate = self
                parser.parse()
            }
//        }
        
        print("Finished?")
        return feedEntries
    }
    
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        eName = elementName
        
//        print(elementName)
        
        if elementName == "item" {
            entryTitle = String()
            entryURL = String()
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        if elementName == "item" {
            let entry = FeedEntry()
            entry.title = entryTitle
            entry.url = entryURL
            
            print("ELEMENT: \(entryTitle) + \(entryURL)")
            
            feedEntries.append(entry)
        }
    }
    
    func parser(parser: NSXMLParser, foundCharacters string: String) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        if (!data.isEmpty) {
            if eName == "title" {
                entryTitle += data
            } else if eName == "link" {
                entryURL += data
            }
        }
    }
}