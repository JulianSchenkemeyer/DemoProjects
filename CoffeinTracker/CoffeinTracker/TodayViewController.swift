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

    @IBOutlet weak var currentCaffeineLabel: UILabel!
    @IBOutlet weak var warningLabel: UILabel!
    @IBOutlet weak var circularProgress: circularProgressBarUIView!
    
    let healthManager = HealthManager()
    var redVal = 0.0
    var currentCaffeineLimit = 300
    let defaults = UserDefaults.standard
    var currentCaffeineMG = 0
    
    override func viewDidAppear(_ animated: Bool) {
        
        //load NSUserDefaults
        let caffeineLimit = defaults.integer(forKey: "dailyCaffeineLimit")
        
        circularProgress.guidelineBackgroundColor = UIColor.white
        
        self.currentCaffeineLimit = caffeineLimit
        
        print("I was opened")
        // add observer
        NotificationCenter.default.addObserver(self, selector: #selector(TodayViewController.setCaffeineToday), name: .UIApplicationDidBecomeActive, object: nil)
        
//        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.coffeinStake), name: Notification.Name(rawValue: coffeinValueChanged), object: nil)
        
//        currentCoffeinLabel.text = String(healthManager.sumTodayInMG())
        setCaffeineToday()
        
//        currentCoffeinLabel.textColor = UIColor.red
        
        self.caffeineStake(currentValue: self.currentCaffeineMG)
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

    func setCaffeineToday() {
        
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
                self.currentCaffeineMG = Int(sum * 1000)
                
//                let currentCaffeineString = NSAttributedString(string: String(self.currentCaffeineMG), attributes: [NSFontAttributeName: UIFont(name: "Chalkduster", size: 30.0)!])

                let currentCaffeineString: NSMutableAttributedString = NSMutableAttributedString(string: String(self.currentCaffeineMG), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 65.0)])
                let unitString = NSAttributedString(string: "mg", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 30.0)])
                
                currentCaffeineString.append(unitString)

//                self.currentCoffeinLabel.text = "\(self.currentCaffeineMG)mg"
                self.currentCaffeineLabel.attributedText = currentCaffeineString
                self.caffeineStake(currentValue: Int(sum * 1000))
                
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
    

    
    
    func caffeineStake(currentValue: Int) {
        
        //
        var stake: Double = 100 / Double(self.currentCaffeineLimit)
        stake = ( stake * Double(self.currentCaffeineMG) ) / 100
        print(stake)
        // restrict stake to 1 if necessary
        if stake > 1.0 {
            stake = 1.0
            
            // configure warning label
            self.warningLabel.isHidden = false
            self.warningLabel.textColor = UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
            let diff = self.currentCaffeineMG - Int(self.currentCaffeineLimit)
            self.warningLabel.text = "Warning!\n Your Caffeinelimit was exceeded by \(diff)mg"
        } else {
            self.warningLabel.isHidden = true
        }
        
        let color = UIColor(displayP3Red: CGFloat(stake), green: 0.0, blue: 0.0, alpha: 1.0)
        
        
        circularProgress.progress = stake
        circularProgress.progressbarColor = color
        
        self.currentCaffeineLabel.textColor = color
        
    }

}

