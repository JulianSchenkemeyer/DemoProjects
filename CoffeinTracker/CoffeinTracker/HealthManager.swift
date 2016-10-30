//
//  HealthManager.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 30/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import HealthKit

class HealthManager: NSObject {
    
    let healthStore = HKHealthStore()
    
    // request read and write permissions
    func requestPermissions(){
        
        // Information we want to read
        let typesToRead = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!])
        
        // Information we want to write
        let typesToShare = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!])
        
        
        self.healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead, completion: { (success, error) -> Void in
            if success == false {
                print("Display not allowed")
            }
        })
        
//        ) { (success, error) -> Void in
//            if success == false {
//                NSLog(" Display not allowed")
//             }

    }
    
    func saveEntry(coffeinValue: Int) {
        
        if let coffeinType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) {
            
            //convert value
            let coffeinValueMG = Double(coffeinValue) * 0.001
            let now = Date()
            
            // create new object which is later pushed
            let object = HKQuantitySample(type: coffeinType, quantity: HKQuantity.init(unit: HKUnit.gram(), doubleValue: coffeinValueMG), start: now, end: now)
            
            //save
            healthStore.save(object, withCompletion: { (success, error) -> Void in
                if error != nil {
                    print("encoutered Error while saving")
                    return
                }
                
                if success {
                    print("new entry saved")
                }
            })
        }
    }
    
    func retrieveEntries() {
        
        if let coffeinType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) {
            
            //sortDescriptor
            
            //query
            let query = HKSampleQuery(sampleType: coffeinType, predicate: nil, limit: 50, sortDescriptors: nil, resultsHandler: { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    print("Error encoutered")
                    return
                }
                
                if let result = tmpResult {
                    var i: Int = 1
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            print("\(i)Coffein: \(sample.quantity.doubleValue(for: HKUnit.gram()))")
                        }
                        i += 1
                    }
                }
            })
            healthStore.execute(query)
        }
        
    }
}
