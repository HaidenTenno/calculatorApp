//
//  Config.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

enum Config {
    
    enum Localization {
        static let cancel = NSLocalizedString("Cancel", comment: "Cancel button in picker toolbar")
        static let done = NSLocalizedString("Done", comment: "Done button in picker toolbar")
        static let error = NSLocalizedString("Error", comment: "Error message")
        static let defaultFirstCurrency = NSLocalizedString("First curr", comment: "Default first selected currenty")
        static let defaultSecondCurrency = NSLocalizedString("Second curr", comment: "Default second selected currenty")
    }
    
    enum StringID {
        static let collectionViewID = "collectionViewID"
        static let sideMenuTableViewID = "tableViewID"
    }
    
    enum Networking {
        static let url = NSLocalizedString("https://www.cbr-xml-daily.ru/daily_eng_utf8.xml", comment: "URL to get data in XML format")
    }
    
    enum NumberPresentation {
        static let strResultDefault = "0"
        static let groupingSize = 3
        static let exponentialSymbol = "e"
        
        /**
         Максимальное число разрядов вводимых и вычисляемых чисел
         
         - important
         Префикс `default` определяет число разрядов, вводимых пользователем
         
         Префикс `showing` определяет число разрядов, которое будет высчитываться и отображаться после вычисления
         */
        enum MaximumDigits {
            // Для калькулятора
            static let defaultInteger = 10
            static let defaultFraction = 10
            static let showingInteger = 100
            static let showingFraction = 20
            // Для ковертера
            static let defaultIntegerConv = 10
            static let defaultFractionConv = 4
        }
    }
    
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
    
}
