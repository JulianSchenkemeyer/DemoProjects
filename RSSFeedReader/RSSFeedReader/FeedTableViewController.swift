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

    var feed: [Item] = []
    var currentFeedTitle: String = "Marco.org"
    var currentFeedURL: String = "https://marco.org/rss2"
    
    var isFirstTime = true
    
    func getFeed() {
        if (isFirstTime) {
            let feedParser = FeedParser()
            feedParser.refreshFeed(currentFeedURL)
        }
        isFirstTime = false
        
        let itemEntry = ItemEntry()
        self.feed = itemEntry.getItems()
        
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.feed.count
    }

    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedEntryTableViewCell

        // Configure the cell...
//        print(indexPath.row)
        let entry = feed[(indexPath as NSIndexPath).row]
        
        
        cell.entryTitleLabel.text = entry.itemTitle
        
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let entry = feed[(indexPath as NSIndexPath).row]
        
        let itemEntry = ItemEntry()
        itemEntry.readItem(itemName: entry.itemTitle!)
        
        print("SELECTED \(entry.itemTitle) + \(entry.itemIsRead)")
        
        //Open Safari Web View
        if let entryURL = URL(string: entry.itemLink!) {

            let svc = SFSafariViewController(url: entryURL)
            self.present(svc, animated: true, completion: nil)
        }
        
        
        
        self.getFeed()
        self.tableView.reloadData()
        
    }
    

    @IBAction func addNewFeed(_ sender: AnyObject) {
        
        
        let alertController = UIAlertController(title: "PlainTextStyle", message: "PlainTextStyle AlertView.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "Login"
        }
        alertController.addTextField(configurationHandler: {
            (textField: UITextField) -> Void in
            textField.placeholder = "Feed URL"
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
            self.currentFeedTitle = (alertController.textFields![0] as UITextField).text!
            self.currentFeedURL = (alertController.textFields![1] as UITextField).text!
            
            print(self.currentFeedTitle + " + " + self.currentFeedURL)
            
            self.getFeed()
            self.title = self.currentFeedTitle
            self.tableView.reloadData()
            
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
        
        
        
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
