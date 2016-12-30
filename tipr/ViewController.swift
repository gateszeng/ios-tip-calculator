//
//  ViewController.swift
//  tipr
//
//  Created by Gates Zeng on 12/16/16.
//  Copyright © 2016 Gates Zeng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var tipLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var billField: UITextField!
    @IBOutlet weak var tipControl: UISegmentedControl!
    let TIMEOUT_INTERVAL: TimeInterval = 60 * 10
    let TRANSFORM_DISTANCE: CGFloat = 50
    let ANIMATE_TIME: TimeInterval = 0.2
    let defaults = UserDefaults.standard
    var resultAlpha: CGFloat = 0

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
        
        // set the alpha of the result depending on the elements in the billField
        if (billField.text == "") {
            resultAlpha = 0
        }
        else {
            resultAlpha = 1
        }
        
        billField.becomeFirstResponder()
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
        // view.endEditing(true)
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
        
        // format the currency into current locale
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        tipLabel.text = formatter.string(from: tipAmount as NSNumber)
        totalLabel.text = formatter.string(from: totalAmount as NSNumber)
        
        // animate
        self.resultView.alpha = resultAlpha
        // billField is no longer empty
        if (resultAlpha == 0 && billField.text != "") {
            resultAlpha = 1;
            UIView.animate(withDuration: ANIMATE_TIME, animations: {
                self.resultView.alpha = self.resultAlpha
            })
            UIView.animate(withDuration: ANIMATE_TIME, delay: 0.0, options: [], animations: { () -> Void in
                    self.resultView.transform = CGAffineTransform(translationX: 0, y: 0)
                    self.billField.transform = CGAffineTransform(translationX: 0, y: 0)
                }, completion: nil)
            
        }
        // billField no longer contains text
        else if (resultAlpha == 1 && billField.text == "") {
            resultAlpha = 0;
            UIView.animate(withDuration: ANIMATE_TIME, animations: {
                self.resultView.alpha = self.resultAlpha
            })
            UIView.animate(withDuration: ANIMATE_TIME, delay: 0.0, options: [], animations: { () -> Void in
                    self.resultView.transform = CGAffineTransform(translationX: 0, y: self.TRANSFORM_DISTANCE)
                    self.billField.transform = CGAffineTransform(translationX: 0, y: self.TRANSFORM_DISTANCE)
                }, completion: nil)
        }
    }
}

