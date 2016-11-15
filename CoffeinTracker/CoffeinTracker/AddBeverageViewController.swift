//
//  AddBeverageViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 06/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit

class AddBeverageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var beverageNameTextField: UITextField!
    @IBOutlet weak var beverageCoffeinTextField: UITextField!
    @IBOutlet weak var beverageSizeTextField: UITextField!
    
    let healthManager = HealthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        healthManager.requestPermissions()
        
        
        self.beverageNameTextField.delegate = self
        self.beverageNameTextField.delegate = self
        self.beverageSizeTextField.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func AddBeverage(_ sender: Any) {
        
        print("Name: \(beverageNameTextField.text) - Coffein: \(beverageCoffeinTextField.text) - Size: \(beverageSizeTextField.text)")
        
        let coffeinValue: Double? = Double(beverageCoffeinTextField.text!)
        let beverageSize: Double? = Double(beverageSizeTextField.text!)
        
        let coffeinEntry = (coffeinValue! / 100) * beverageSize!
        
        healthManager.saveEntry(coffeinValue: coffeinEntry)
        
        self.navigationController!.popViewController(animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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

