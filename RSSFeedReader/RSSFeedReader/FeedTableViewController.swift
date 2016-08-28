//
//  FeedTableViewController.swift
//  RSSFeedReader
//
//  Created by Julian Schenkemeyer on 26/08/16.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import SafariServices

class FeedTableViewController: UITableViewController {

    var feed: [FeedEntry] = []
    var currentFeedTitle: String = "Marco.org"
    var currentFeedURL: String = "https://marco.org/rss2"
    
    func getFeed() {
        let feedParser = FeedParser()
        self.feed = feedParser.refreshFeed(currentFeedURL)
        
        print(self.feed.count)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.getFeed()
        
        let titleLabel: UILabel = UILabel()
        titleLabel.text = currentFeedTitle
        
        self.title = currentFeedTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feed.count
    }

    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! FeedEntryTableViewCell

        // Configure the cell...
//        print(indexPath.row)
        let feedEntry = feed[indexPath.row]
        
        
        cell.entryTitleLabel.text = feedEntry.title
        
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let feedEntry = feed[indexPath.row]
        
        print("SELECTED \(feedEntry.title)")
        
        //Open Safari Web View
        if let entryURL = NSURL(string: feedEntry.url) {
        
            let svc = SFSafariViewController(URL: entryURL)
            self.presentViewController(svc, animated: true, completion: nil)
        }
        
    }
    

    @IBAction func addNewFeed(sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "PlainTextStyle", message: "PlainTextStyle AlertView.", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField : UITextField) -> Void in
            textField.placeholder = "Login"
        }
        alertController.addTextFieldWithConfigurationHandler({
            (textField: UITextField) -> Void in
            textField.placeholder = "Feed URL"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            
            self.currentFeedTitle = (alertController.textFields![0] as UITextField).text!
            self.currentFeedURL = (alertController.textFields![1] as UITextField).text!
            
            print(self.currentFeedTitle + " + " + self.currentFeedURL)
            
            self.getFeed()
            self.title = self.currentFeedTitle
            self.tableView.reloadData()
            
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        
        
        
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
