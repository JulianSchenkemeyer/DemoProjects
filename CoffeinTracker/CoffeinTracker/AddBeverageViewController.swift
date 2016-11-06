//
//  AddBeverageViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 06/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class AddBeverageViewController: UIViewController {

    @IBOutlet weak var beverageNameTextField: UITextField!
    @IBOutlet weak var beverageCoffeinTextField: UITextField!
    @IBOutlet weak var beverageSizeTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func AddBeverage(_ sender: Any) {
        
        print("Name: \(beverageNameTextField.text) - Coffein: \(beverageCoffeinTextField.text) - Size: \(beverageSizeTextField.text)")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
