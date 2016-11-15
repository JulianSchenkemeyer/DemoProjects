//
//  ViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 25/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    @IBOutlet weak var currentCoffeinLabel: UILabel!
    
    let healthManager = HealthManager()
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("I was opened")
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.setCoffeinToday), name: .UIApplicationDidBecomeActive, object: nil)
        
//        currentCoffeinLabel.text = String(healthManager.sumTodayInMG())
        setCoffeinToday()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        healthManager.requestPermissions()
//        healthManager.saveEntry(coffeinValue: 75)
//        healthManager.retrieveEntries()
    }

    override func viewDidDisappear(_ animated: Bool) {
        print("I was closed")
        
        // remove observer
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setCoffeinToday() {
        
        healthManager.requestPermissions()
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
     
        // Getting current time intervall
        let cal = Calendar.current
        let comp = cal.dateComponents([.year, .month, .day], from: Date())
        let todayStart = cal.date(from: comp)
        let todayEnd = todayStart?.addingTimeInterval(60 * 60 * 24)
        
        let predicate = HKQuery.predicateForSamples(withStart: todayStart, end: todayEnd, options: [])
        
        healthManager.retrieveEntries(pred: predicate, sortDes: [sortDescriptor], completion: { (results) -> Void in
            
            var sum: Double = 0.0
            
            for entry in results {
                sum += entry.quantity.doubleValue(for: HKUnit.gram())
            }
            
            //Set Label
            DispatchQueue.main.async(execute: { () -> Void in
                self.currentCoffeinLabel.text = String(Int(sum * 1000))
            })
            
        })
        
    }
    

}

