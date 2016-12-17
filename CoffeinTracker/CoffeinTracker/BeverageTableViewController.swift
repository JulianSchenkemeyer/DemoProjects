//
//  BeverageTableViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 26/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import CoreData

class BeverageTableViewController: UITableViewController {
    
    var beverages: [Beverage] = []
    let healthManager = HealthManager()
    var currentSelected = -1
    var currentExpanded = -1
    var currentExpandedIndexPath: IndexPath?

    override func viewWillAppear(_ animated: Bool) {
        let context = self.getContext()
        
        do {
            beverages = try context.fetch(Beverage.fetchRequest())
        } catch {
            print("Failed!!!")
        }
        
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getContext() -> NSManagedObjectContext {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return context
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        var beverageCount = 0
        if (self.currentExpanded != -1) {
            beverageCount = beverages.count + 1
        } else {
            beverageCount = beverages.count
        }
        
        return beverageCount
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(indexPath.row)
        
        if (self.currentExpanded >= 0) {
            
            if (self.currentExpanded == indexPath.row) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "ChooseSizeCell", for: indexPath) as! ChooseBeverageSizeTableViewCell
                cell.items = [125, 330, 500]
                
                return cell
            } else if (self.currentExpanded < indexPath.row) {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell", for: indexPath) as! BeverageTableViewCell
                
                // Configure the cell...
                cell.beverageNameLabel.text = beverages[indexPath.row - 1].name
                cell.beverageCaffeineLabel.text = String(beverages[indexPath.row - 1].caffeine) + " mg/100ml"
                
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell", for: indexPath) as! BeverageTableViewCell
                
                // Configure the cell...
                cell.beverageNameLabel.text = beverages[indexPath.row].name
                cell.beverageCaffeineLabel.text = String(beverages[indexPath.row].caffeine) + " mg/100ml"
                
                return cell
            }
            
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BeverageCell", for: indexPath) as! BeverageTableViewCell
            
            // Configure the cell...
            cell.beverageNameLabel.text = beverages[indexPath.row].name
            cell.beverageCaffeineLabel.text = String(beverages[indexPath.row].caffeine) + " mg/100ml"
            
            return cell
        }

//        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var cellHeight = 44.0
        if (self.currentExpanded >= 0 && self.currentExpanded == indexPath.row) {
            cellHeight = 80.0
        }
        return CGFloat(cellHeight)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        healthManager.requestPermissions()
//        
//        let selectedBeverage = beverages[indexPath.row]
//        
//        let calcCaffeineValue = (selectedBeverage.caffeine / 100) * 330
//        
//        healthManager.saveEntry(coffeinValue: calcCaffeineValue)
//        
//        self.navigationController!.popViewController(animated: true)
        
        if (self.currentSelected != indexPath.row) {
            
            
            //expand
//            tableView.beginUpdates()
            //collapse if another tablecell is already expanded
            var adjustedIndexPath = indexPath
            
            if (self.currentExpanded != -1) {
                if (indexPath.row >= self.currentExpanded) {
                    adjustedIndexPath.row -= 1
                }
                
                tableView.beginUpdates()
                let indexToDelete = IndexPath.init(row: self.currentExpanded, section: 0)
                self.tableView.deleteRows(at: [indexToDelete], with: .fade)
                
                self.currentSelected = -1
                self.currentExpanded = -1
                tableView.endUpdates()
                
            }
            tableView.beginUpdates()
            
            self.currentSelected = adjustedIndexPath.row
            self.currentExpanded = adjustedIndexPath.row + 1
            
            
            var newIndexPath = adjustedIndexPath
            newIndexPath.row += 1
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            tableView.endUpdates()
            
        } else if (self.currentSelected == indexPath.row) {
            self.currentSelected = -1
            self.currentExpanded = -1
            
            //collapse
            tableView.beginUpdates()
            var newIndexPath = indexPath
            newIndexPath.row += 1
            tableView.deleteRows(at: [newIndexPath], with: .fade)
            tableView.endUpdates()
            
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
