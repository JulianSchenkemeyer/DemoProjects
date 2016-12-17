//
//  ChooseBeverageSizeTableViewCell.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 07/12/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class ChooseBeverageSizeTableViewCell: UITableViewCell {

    @IBOutlet weak var sizeCollectionView: UICollectionView!
    
    var items: [Int] = []
    var beverageCaffeine: Double = 0.0
    var navigationController: UINavigationController?
}
extension ChooseBeverageSizeTableViewCell: UICollectionViewDelegate {
    
}


extension ChooseBeverageSizeTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "sizeCell", for: indexPath) as! SizeCollectionViewCell
        
        cell.sizeLabel.textAlignment = NSTextAlignment.center
        if (indexPath.row < 3) {
            cell.sizeLabel.text = "\(items[indexPath.row])ml"
        } else {
            cell.sizeLabel.text = "Other"
        }
        
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (indexPath.row < 3) {
            print("\(items[indexPath.row])ml + \(beverageCaffeine)")
            
            //calculate corresponding caffeine value
            let calcCaffeineValue = (beverageCaffeine / 100) * Double(items[indexPath.row])
            
            //add value to healthKit
            let healthManager = HealthManager()
            healthManager.requestPermissions()
            healthManager.saveEntry(coffeinValue: calcCaffeineValue)
            
            
            navigationController!.popViewController(animated: true)
            
            
            
//                healthManager.requestPermissions()
//        
//                let selectedBeverage = beverages[indexPath.row]
//        
//                let calcCaffeineValue = (selectedBeverage.caffeine / 100) * 330
//        
//                healthManager.saveEntry(coffeinValue: calcCaffeineValue)
//        
//                self.navigationController!.popViewController(animated: true)
            
        } else {
            print("Other")
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


