//
//  Config.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

enum Config {
    
    static let collectionViewID = "collectionViewID"
    static let sideMenuTableViewID = "tableViewID"
    static let fontName = "ALS SPb"
    static let strResultDefault = "0"
    
    enum CalculatorButtonSize {
        static let width = 70
        static let hight = 70
    }
    
    enum MaximumDigits {
        static let defaultInteger = 10
        static let defaultFraction = 10
        static let showingInteger = 100
        static let showingFraction = 20
    }
    
    enum Colors {
        static let backgroud = UIColor.systemGray6
        static let label = UIColor.label
        static let numberButton = UIColor(red: 248.0/255.0, green: 188.0/255.0, blue: 78.0/255.0, alpha: 1.0)
        static let functionButton = UIColor(red: 76.0/255.0, green: 169.0/255.0, blue: 203.0/255.0, alpha: 1.0)
        static let functionButtonSelected = UIColor(red: 100.0/255.0, green: 130.0/255.0, blue: 150.0/255.0, alpha: 1.0)
        static let buttonText = UIColor.label
    }
}
