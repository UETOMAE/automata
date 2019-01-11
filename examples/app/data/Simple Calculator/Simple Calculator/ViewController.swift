//
//  ViewController.swift
//  Simple Calculator
//
//  Created by MORI Naohiko on 2019/01/09.
//  Copyright © 2019 MORI Naohiko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var leftValue: UITextField!
    @IBOutlet weak var rightValue: UITextField!
    @IBOutlet weak var operand: UITextField!
    @IBOutlet weak var result: UILabel!
    
    var arithmetic = ["+", "-", "*", "/"]
    
    @IBAction func calculate(_ sender: Any) {
        if leftValue.text?.isEmpty ?? true || rightValue.text?.isEmpty ?? true {
            result.text = "Input both values"
        } else if operand.text?.isEmpty ?? true {
            result.text = "Input operand"
        } else {
            let LeftNum: Int = Int(leftValue.text!)!
            let RightNum: Int = Int(rightValue.text!)!
            switch operand.text! {
            case "+":
                result.text = String(LeftNum + RightNum)
            case "-":
                result.text = String(LeftNum - RightNum)
            case "*":
                result.text = String(LeftNum * RightNum)
            case "/":
                if RightNum == 0 {
                    result.text = "Division by zero"
                } else {
                    result.text = String(LeftNum / RightNum)
                }
            default:
                result.text = "Invalid operand"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arithmetic.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arithmetic[row]
    }

}

