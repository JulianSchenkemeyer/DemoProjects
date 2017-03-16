//
//  SettingsViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 16/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import HealthKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var caffeineLimitSlider: UISlider!
    @IBOutlet weak var maxCaffeineLabel: UILabel!
    @IBOutlet weak var minCaffeineLabel: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    
    var currentCaffeineLimit: Int = 300
    let defaults = UserDefaults.standard
    let healthManager = HealthManager()

    override func viewWillAppear(_ animated: Bool) {
        //load NSUserDefaults
        let temp = defaults.integer(forKey: "dailyCaffeineLimit")
        self.currentCaffeineLimit = temp
        self.caffeineLimitSlider.value = Float(self.currentCaffeineLimit)
        self.currentValue.text = "\(Int(self.caffeineLimitSlider.value))"
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxCaffeineLabel.text = "400"
        self.minCaffeineLabel.text = "0"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    
        let value = Int(sender.value)
        self.currentValue.text = "\(value)"
        
        self.currentCaffeineLimit = value
        
        self.defaults.set(value, forKey: "dailyCaffeineLimit")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier! == "SettingsSegue") {
            let destViewController = (segue.destination as! TodayViewController)
            destViewController.currentCaffeineLimit = self.currentCaffeineLimit
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
//        let parentVC = parent as! ViewController
//        if (parent.)
//        parent.curren t CoffeinLimit = self.currentCoffeinLimit
//        if (parent.ise)
        print("back")
    }
    
    // recommend a daily limit based on a persons weight
    @IBAction func recommendLimit(_ sender: Any) {
        
        
        healthManager.getWeight(completion: {
            (rlimit) -> Void in
            self.currentCaffeineLimit = rlimit
            self.defaults.set(rlimit, forKey: "dailyCaffeineLimit")
            
            DispatchQueue.main.async(execute: {
                () -> Void in
                self.currentValue.text = "\(rlimit)"
                self.caffeineLimitSlider.value = Float(rlimit)
            })

        })
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("I was closed")
        
        
    }

}
