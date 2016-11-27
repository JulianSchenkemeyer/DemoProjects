//
//  ViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 25/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import HealthKit

class TodayViewController: UIViewController {

    @IBOutlet weak var currentCoffeinLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var circularProgress: circularProgressBarUIView!
    
    let healthManager = HealthManager()
    var redVal = 0.0
    var currentCoffeinLimit = 300
    let defaults = UserDefaults.standard
    
    override func viewDidAppear(_ animated: Bool) {
        
        //load NSUserDefaults
        let coffeinLimit = defaults.integer(forKey: "dailyCoffeinLimit")
        
        circularProgress.guidelineBackgroundColor = UIColor.white
        
        self.currentCoffeinLimit = coffeinLimit
        
        print("I was opened")
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(TodayViewController.setCoffeinToday), name: .UIApplicationDidBecomeActive, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.coffeinStake), name: Notification.Name(rawValue: coffeinValueChanged), object: nil)
        
//        currentCoffeinLabel.text = String(healthManager.sumTodayInMG())
        setCoffeinToday()
        
//        currentCoffeinLabel.textColor = UIColor.red
        
        self.coffeinStake(currentValue: Int(self.currentCoffeinLabel.text!)!)
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
                self.coffeinStake(currentValue: Int(sum * 1000))
                
                self.view.layoutIfNeeded()
            })
            
        })
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier! == "SettingsSegue") {
//            let destViewController = (segue.destination as! SettingsViewController)
//            destViewController.currentCoffeinLimit = self.currentCoffeinLimit
//            destViewController.parentVC = self
//        }
    }
    

    
    
    func coffeinStake(currentValue: Int) {
        
        //
        var stake: Double = 100 / Double(self.currentCoffeinLimit)
        stake = ( stake * Double(self.currentCoffeinLabel.text!)! ) / 100
        print(stake)
        // restrict stake to 1 if necessary
        if stake > 1.0 {
            stake = 1.0
            
            // configure warning label
            self.warningLabel.isHidden = false
            self.warningLabel.textColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            let diff = Int(self.currentCoffeinLabel.text!)! - Int(self.currentCoffeinLimit)
            self.warningLabel.text = "Warning!\n Your Caffeinelimit was exceeded by \(diff)mg"
        } else {
            self.warningLabel.isHidden = true
        }
        
        let color = UIColor(displayP3Red: CGFloat(stake), green: 0.0, blue: 0.0, alpha: 1.0)
        
        
        circularProgress.progress = stake
        circularProgress.progressbarColor = color
        
        self.currentCoffeinLabel.textColor = color
        
    }

}

