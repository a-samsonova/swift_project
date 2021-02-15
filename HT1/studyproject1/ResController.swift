//
//  ResController.swift
//  studyproject1
//
//  Created by Александра Самсонова on 14.02.2021.
//

import UIKit


class ResController: UIViewController {

    @IBOutlet weak var res_label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let strres = String(describing: SumManager.shared.sum!.sumval)
        res_label.text = strres
    }
}
