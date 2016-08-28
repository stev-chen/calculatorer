//
//  ViewController.swift
//  Calculator
//
//  Created by Steven Chen on 2016-07-01.
//  Copyright © 2016 Steven Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private func forTrailingZero(dblVar: Double) -> String{
        let strVar = String(format: "%.10g", dblVar)
        return strVar
    }
    
    
    @IBOutlet private weak var display: UILabel!
    @IBOutlet private weak var history: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    
    private var decimalAlreadyPresent = false
    
    @IBAction func touchDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if digit == "."{
            let textCurrentlyInDisplay = display.text!
            if !userIsInTheMiddleOfTyping{
                display.text = "0."
                userIsInTheMiddleOfTyping = true
            }
            if display.text!.rangeOfString(".") == nil{
                display.text = textCurrentlyInDisplay + digit
            }
        } else if userIsInTheMiddleOfTyping {
            let textCurrentlyInDisplay = display.text!
            display.text = textCurrentlyInDisplay + digit
        } else {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
    }
    
    var operHistory: String {
        get{
            return history.text!
        }
        set{
            history.text = String(newValue)
        }
    }
    
    var displayValue: Double {
        get{
            return Double(display.text!)! //assumes always a convertable to a double, otherwise will crash
        }
        set{
            display.text = forTrailingZero(newValue)
        }
    }
    private var brain = CalculatorBrain()
    
    @IBAction func performOperation(sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            //operHistory += " " + display.text! + sender.currentTitle
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
            decimalAlreadyPresent = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
        operHistory = brain.currentHistory
        if operHistory != " "{
            operHistory += " = "
        }
    }
}

