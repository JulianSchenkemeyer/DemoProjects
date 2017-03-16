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
        var typesToRead = Set([HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.dietaryCaffeine)!])
        typesToRead.insert(HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass)!)
        
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
    func retrieveEntries(pred: NSPredicate, sortDes: [NSSortDescriptor], completion: @escaping ([HKQuantitySample]) -> Void) {
        
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
                completion(resultSet)
                
            })
            healthStore.execute(query)
        }
        
    }
    
    func getWeight(completion: @escaping (Int) -> Void) {
        if let weightType = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.bodyMass) {
            
            let weightQuery = HKSampleQuery(sampleType: weightType, predicate: nil, limit: 1, sortDescriptors: nil, resultsHandler: {
                (query, results, error) -> Void in
                
                if error != nil {
                    print("Error encoutered")
                    return
                }
                
                if let tmpResult = results {
                    if tmpResult.count != 0{
                        let weight = tmpResult[0] as? HKQuantitySample
                        
                        let weightDouble = (weight?.quantity.doubleValue(for: HKUnit.gram()))! / 1000
                        let rlimit = Int(weightDouble) * 6
                        print("\(weight?.quantity) + \(weightDouble) + \(rlimit)")
                        
                        completion(rlimit)
                        
                    } else {
                        print("no entry")
                    }
                }
            })
            HKHealthStore().execute(weightQuery)
        }

    }
    
}
