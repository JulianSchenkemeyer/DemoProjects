//
//  AddBeverageViewController.swift
//  CoffeinTracker
//
//  Created by Julian Schenkemeyer on 06/11/2016.
//  Copyright © 2016 Julian Schenkemeyer. All rights reserved.
//

import UIKit
import CoreData

class AddBeverageViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var beverageNameTextField: UITextField!
    @IBOutlet weak var beverageCaffeineTextField: UITextField!
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
    
    
    func getContext() -> NSManagedObjectContext {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        return context
    }
    
    func saveContext() {
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    

    @IBAction func AddBeverage(_ sender: Any) {
        
        print("Name: \(beverageNameTextField.text) - Caffeine: \(beverageCaffeineTextField.text) - Size: \(beverageSizeTextField.text)")
        
        if (!(beverageCaffeineTextField.text?.isEmpty)! && !(beverageCaffeineTextField.text?.isEmpty)!) {
            let caffeineValue: Double? = Double(beverageCaffeineTextField.text!)

            // get Core Data Context
            let context = self.getContext()
        
            // create Core Data Object
            let beverage = Beverage(context: context)
            beverage.name = beverageNameTextField.text
            beverage.caffeine = caffeineValue!
        
            self.saveContext()
        
            self.navigationController!.popViewController(animated: true)
        
        } else {
            let alertController = UIAlertController(title: "Size and/or Caffeine Amount missing", message: "", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: {
                alert -> Void in
                
                
            }))
            self.present(alertController, animated: true, completion: nil)
        }
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

