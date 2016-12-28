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
    let TIMEOUT_INTERVAL: TimeInterval = 60 * 10
    let defaults = UserDefaults.standard

    override func viewWillAppear(_ animated: Bool) {
        // check for when the app returns from background to foreground
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        // check for when the app goes to background
        NotificationCenter.default.addObserver(self, selector: #selector(willResignActive), name: .UIApplicationWillResignActive, object: nil)
        
        // load from UserDefaults
        tipControl.selectedSegmentIndex = defaults.integer(forKey: "segmentDefault")

        // makes the initial call to set up previous bill
        willEnterForeground()
    }
    
    func willEnterForeground() {
        let previousTime = defaults.object(forKey: "exitTime") as? NSDate
        
        // if <10 min, show previous bill
        billField.text = ""
        if (previousTime != nil) {
            let currTime = NSDate()
            let timeout = currTime.timeIntervalSince(previousTime as! Date)
            
            if (timeout <= TIMEOUT_INTERVAL) {
                billField.text = defaults.string(forKey: "billDefault") ?? ""
            }
        }
        calculateTip(self)
    }
    
    func willResignActive() {
        // set the exit time
        defaults.set(NSDate(), forKey: "exitTime")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        willResignActive()
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
        defaults.set(tipControl.selectedSegmentIndex, forKey: "segmentDefault")
        defaults.set(billField.text, forKey: "billDefault")
        defaults.synchronize()
        
        tipLabel.text = String(format: "$%.2f", tipAmount)
        totalLabel.text = String(format: "$%.2f", totalAmount)
    }
    
    
}

