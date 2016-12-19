//
//  ViewController.swift
//  tipr
//
//  Created by Gates Zeng on 12/16/16.
//  Copyright © 2016 Gates Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!

    override func viewWillAppear(_ animated: Bool) {
        // load from UserDefaults
        let defaults = UserDefaults.standard
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "segmentIndex")
        calculateTip(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    @IBAction func calculateTip(_ sender: AnyObject) {
        let tipPercentages = [0.15, 0.17, 0.20]
        let billAmount = Double(billField.text!) ?? 0
        let tipAmount = billAmount * tipPercentages[tipControl.selectedSegmentIndex]
        let totalAmount = billAmount + tipAmount
        
        // store tipPercentage to UserDefaults
        let defaults = UserDefaults.standard
        defaults.set(tipControl.selectedSegmentIndex, forKey: "segmentIndex")
        defaults.synchronize()
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
    }
    
    
}

