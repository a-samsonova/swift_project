//
//  ViewController.swift
//  Calculator_Project
//
//  Created by Александра Самсонова on 22.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!
    
    var typing = false
    var dotPlaced = false
    var firstOperand = 0.0
    var secondOperand = 0.0
    var operationSign = ""

    var currentInput:Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                resultLabel.text = "\(valueArray[0])"
            }
            else {
                resultLabel.text = "\(newValue)"
            }
            
            typing = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func digitButton(_ sender: UIButton) {
        let number = sender.currentTitle!
        if typing{
            resultLabel.text = resultLabel.text! + number
        }
        else{
            resultLabel.text = number
            typing = true
        }
    }
    
    @IBAction func signPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        typing = false
        dotPlaced = false
    }
    
    func operating(operation: (Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        typing = false
    }
    
    @IBAction func resultSignPressed(_ sender: UIButton) {
        if typing{
            secondOperand = currentInput
        }
        
        dotPlaced = false
        
        switch operationSign{
        case "+":
            operating{$0 + $1}
        case "-":
            operating{$0 - $1}
        case "*":
            operating{$0 * $1}
        case "/":
            operating{$0 / $1}
        default: break
        }
    }
    
    
    @IBAction func clearButton(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        resultLabel.text = "0"
        typing = false
        dotPlaced = false
        operationSign = ""
    }
    
    @IBAction func changeSign(_ sender: UIButton) {
        currentInput = -currentInput
    }
    
    @IBAction func percentageButton(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        }
        else {
            secondOperand = firstOperand * currentInput / 100
        }
        typing = false
    }
    
    @IBAction func dotButton(_ sender: UIButton) {
        if typing && !dotPlaced {
            resultLabel.text = resultLabel.text! + "."
            dotPlaced = true
        }
        else if !typing && !dotPlaced {
            resultLabel.text = "0."
            dotPlaced = true
            typing = true
       }
    }
}
