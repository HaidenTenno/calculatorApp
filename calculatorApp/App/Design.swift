//
//  Design.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 14.11.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

enum Design {
    static let fontName = "ALS SPb"
    
    enum RoundButtonSize {
        static let width = 70
        static let hight = 70
    }
    
    enum Colors {
        static let backgroud = UIColor.systemGray6
        static let label = UIColor.label
        static let numberButton = UIColor(red: 253.0/255.0, green: 187.0/255.0, blue: 19.0/255.0, alpha: 1.0)
        static let functionButton = UIColor(red: 3.0/255.0, green: 172.0/255.0, blue: 205.0/255.0, alpha: 1.0)
        static let functionButtonSelected = UIColor(red: 3.0/255.0, green: 140.0/255.0, blue: 160.0/255.0, alpha: 1.0)
        static let buttonText = UIColor.label
    }
    
    enum Images {
        static let horisontalLines = "line.horizontal.3"
        static let arrowUpDown = "arrow.up.arrow.down"
    }
}
