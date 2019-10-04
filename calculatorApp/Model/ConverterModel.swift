//
//  ConverterModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

final class ConverterModel {
    
    var items: [CalculatorButtonItem] = []
    
    var valute: [String:Currency] = [:]
    
    var firstSelectedCurrency: Currency?
    var secondSelectedCurrency: Currency?
    
    init() {
        
        for numberItem in CalculatorButtonNumericValue.allCases {
            let item = CalculatorButtonNumberItem(value: numberItem)
            if item.value == .pi { continue }
            items.append(item)
        }
        
        let clearItem = CalculatorButtonOperationItem(value: .clear)
        items.append(clearItem)
    }
    
    func setValute(_ valute: [String:Currency]) {
        self.valute = valute
        self.valute["RUB"] = Currency(
            id: "None",
            numCode: "None",
            charCode: "RUB",
            nominal: 1,
            name: "Российский рубль",
            value: 1.0,
            previous: 1.0)
        firstSelectedCurrency = self.valute["RUB"]
        secondSelectedCurrency = self.valute["USD"]
    }
}
