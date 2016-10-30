//
//  ViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 25/10/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let healthManager = HealthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        healthManager.requestPermissions()
        healthManager.saveEntry(coffeinValue: 75)
        healthManager.retrieveEntries()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

