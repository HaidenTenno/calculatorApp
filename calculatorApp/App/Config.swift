//
//  Config.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

enum Config {
    
    static let dafaultResultText = "0"
    static let collectionViewID = "collectionViewID"
    
    enum CalculatorButtonSize {
        static let width = 70
        static let hight = 70
    }
    
    enum MaximumDigits {
        static let integer = 10
        static let fraction = 10
    }
}
