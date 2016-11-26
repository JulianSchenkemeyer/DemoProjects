//
//  SettingsViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 16/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var coffeinLimitSlider: UISlider!
    @IBOutlet weak var maxCoffeinLabel: UILabel!
    @IBOutlet weak var minCoffeinLabel: UILabel!
    @IBOutlet weak var currentValue: UILabel!
    
    var currentCoffeinLimit: Int = 300
    let defaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        //load NSUserDefaults
        let temp = defaults.integer(forKey: "dailyCoffeinLimit") 
        self.currentCoffeinLimit = temp
        self.coffeinLimitSlider.value = Float(self.currentCoffeinLimit)
        self.currentValue.text = "\(Int(self.coffeinLimitSlider.value))"
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxCoffeinLabel.text = "400"
        self.minCoffeinLabel.text = "0"
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func sliderValueChanged(_ sender: UISlider) {
    
        let value = Int(sender.value)
        self.currentValue.text = "\(value)"
        
        self.currentCoffeinLimit = value
        
        self.defaults.set(value, forKey: "dailyCoffeinLimit")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier! == "SettingsSegue") {
            let destViewController = (segue.destination as! TodayViewController)
            destViewController.currentCoffeinLimit = self.currentCoffeinLimit
        }
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        
//        let parentVC = parent as! ViewController
//        if (parent.)
//        parent.curren t CoffeinLimit = self.currentCoffeinLimit
//        if (parent.ise)
        print("back")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        print("I was closed")
        
        
    }

}
