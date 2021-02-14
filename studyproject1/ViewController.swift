//
//  ViewController.swift
//  studyproject1
//
//  Created by Александра Самсонова on 11.02.2021.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showRes(_ sender: UIButton) {
        guard
            let text = textField?.text,
            text.count > 0
        else {
            label.textColor = .red
            return
        }
        
        label.textColor = .black
        
        let arrayInt = text.components(separatedBy: " ").compactMap { Int($0) }
        var sum = 0

        for item in arrayInt {
            sum += item
        }
    
//        performSegue(withIdentifier: "showsum", sender: sender)
    }
} 

