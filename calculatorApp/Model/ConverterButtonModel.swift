//
//  ConverterButtonModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

final class ConverterButtonModel {
    
    var items: [CalculatorButtonNumberItem] = []
    
    init() {
        
        for numberItem in CalculatorButtonNumericValue.allCases {
            let item = CalculatorButtonNumberItem(value: numberItem)
            if item.value == .pi { continue }
            items.append(item)
        }
    }
}
