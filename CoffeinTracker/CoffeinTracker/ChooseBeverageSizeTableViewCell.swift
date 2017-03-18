//
//  ChooseBeverageSizeTableViewCell.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 07/12/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import CoreData

class ChooseBeverageSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    var items: [Size] = []
    var favItems: [Size] = []
    var beverageCaffeine: Double = 0.0
    var navigationController: UINavigationController?
    var currentBeverage: Beverage?
    
}
extension ChooseBeverageSizeTableViewCell: UICollectionViewDelegate {
    
}


extension ChooseBeverageSizeTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
//        return currentBeverage?.beverageHasSizes?.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! SizeCollectionViewCell
        
        cell.sizeLabel.textAlignment = NSTextAlignment.center
        if (indexPath.row < 3) {
            cell.sizeLabel.text = "\(Int(favItems[indexPath.row].ml))ml"
//            cell.sizeLabel.text =
        } else {
            cell.sizeLabel.text = "Other"
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row < 3) {
            print("\(favItems[indexPath.row])ml + \(beverageCaffeine)")
            
            //calculate corresponding caffeine value
            let calcCaffeineValue = (beverageCaffeine / 100) * Double(favItems[indexPath.row].ml)
            
            //add value to healthKit
            let healthManager = HealthManager()
            healthManager.requestPermissions()
            healthManager.saveEntry(coffeinValue: calcCaffeineValue)
            
            //increment timesConsumed-attribute of selected beverage
            currentBeverage?.timesConsumed += 1
            print("beverage consumed: \(currentBeverage?.timesConsumed)")
            favItems[indexPath.row].timesUsed += 1
            print("size used: \(favItems[indexPath.row].timesUsed)")
            
            
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
            navigationController!.popViewController(animated: true)
            
        } else {
            print("Other")
            
            //TODO: Use something more appropriate than AlertController in order to enable custom sizes
            
            let alertController = UIAlertController(title: "Custom Beveragesize", message: "", preferredStyle: .alert)
            
            // UITextfield for custom size
            alertController.addTextField(configurationHandler: {
                (textField) -> Void in
                
                textField.placeholder = "Size in ml"
                textField.textAlignment = .center
                textField.keyboardType = .numberPad
            })
            
            // OK-Action
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                
                print("OK")
                
                let customSizeTextfield = alertController.textFields![0] as UITextField
                
                //calculate corresponding caffeine value
                if (!(customSizeTextfield.text?.isEmpty)!) {
                    let calcCaffeineValue = (self.beverageCaffeine / 100) * Double(customSizeTextfield.text!)!
                
                    //add value to healthKit
                    let healthManager = HealthManager()
                    healthManager.requestPermissions()
                    healthManager.saveEntry(coffeinValue: calcCaffeineValue)
                    
                    
                    //check if size already exists
                    var position = 0
                    var i = 0
                    for item in self.items {
                        if item.ml == Double(customSizeTextfield.text!)! {
                            position = i + 1
                        }
                        i += 1
                    }
                    
                    if (position != 0) {
                        self.items[position - 1].timesUsed += 1
                    } else {
                        //create new Size-Entry for this beverage
                        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                        let newSize = Size(context: context)
                        
                        newSize.ml = Double(customSizeTextfield.text!)!
                        newSize.timesUsed = 1
                        newSize.sizeForBeverage = self.currentBeverage
                    }
                    
                    (UIApplication.shared.delegate as! AppDelegate).saveContext()
                }
                self.navigationController!.popViewController(animated: true)
            }))
            
            // Cancel-Action
            alertController.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { alert -> Void in
                
                print("Cancel")
            }))
            
//            self.present(alertController, animated: true, completion: nil)
            UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
}

//extension ChooseBeverageSizeTableViewCell: UICollectionViewDelegateFlowLayout {
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemsPerRow:CGFloat = 4
//        let hardCodedPadding:CGFloat = 5
//        let itemWidth = (collectionView.bounds.width / itemsPerRow) - hardCodedPadding
//        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
//        return CGSize(width: itemWidth, height: itemHeight)
//    }
//    
//}
    
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }


