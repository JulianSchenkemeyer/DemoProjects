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
    
    func saveEntry(coffeinValue: Double) {
        
        if let coffeinType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) {
            
            //convert value
            let coffeinValueMG = coffeinValue * 0.001
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
    
    //TODO predicate parameter, sortDescriptor
    func retrieveEntries(pred: NSPredicate, sortDes: [NSSortDescriptor]) -> [HKQuantitySample] {
        
        //Prepare ResultSet
        var resultSet: [HKQuantitySample] = []
        
        if let coffeinType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine) {
            
            
            
            //sortDescriptor
            
            //query
            let query = HKSampleQuery(sampleType: coffeinType, predicate: pred, limit: 50, sortDescriptors: sortDes, resultsHandler: { (query, tmpResult, error) -> Void in
                
                if error != nil {
                    print("Error encoutered")
                    return
                }
                
                if let result = tmpResult {
                    var i: Int = 1
                    for item in result {
                        if let sample = item as? HKQuantitySample {
                            print("\(i)Coffein: \(sample.quantity.doubleValue(for: HKUnit.gram()))")
                            resultSet.append(sample)
                        }
                        i += 1
                    }
                }
                
            })
            healthStore.execute(query)
        }
        return resultSet
    }
    
    
    func retrieveEntriesFromToday() -> [HKQuantitySample] {
    
        var results: [HKQuantitySample] = []
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
        
        //Getting current time intervall
        let cal = Calendar.current
        let comp = cal.dateComponents([.year, .month, .day], from: Date())
        let todayStart = cal.date(from: comp)
        let todayEnd = todayStart?.addingTimeInterval(60 * 60 * 24)
        
        let predicate = HKQuery.predicateForSamples(withStart: todayStart, end: todayEnd, options: [])
        
        
        results = retrieveEntries(pred: predicate, sortDes: [sortDescriptor])
        
        
        return results
    }
    
    func sumTodayInMG() -> Int {
        let results = retrieveEntriesFromToday()
        var sum: Double = 0.0
        
        for entry in results {
            sum += entry.quantity.doubleValue(for: HKUnit.gram())
        }
        
        return Int(sum * 1000)
    }
}
