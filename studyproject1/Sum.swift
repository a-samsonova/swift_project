//
//  Sum.swift
//  studyproject1
//
//  Created by Александра Самсонова on 14.02.2021.
//

import Foundation

class Sum {
    let sumval: Int
    
    init(sumval: Int) {
        self.sumval = sumval
    }
}

class SumManager {
    
    static let shared = SumManager()
    private init() { }
    
    var sum: Sum? = nil
}
