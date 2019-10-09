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
    
    var valute: [XMLCurrency] = []
    
    var firstSelectedCurrency: XMLCurrency?
    var secondSelectedCurrency: XMLCurrency?
    
    init() {
        
        for numberItem in CalculatorButtonNumericValue.allCases {
            let item = CalculatorButtonNumberItem(value: numberItem)
            if item.value == .pi { continue }
            items.append(item)
        }
        
        let clearItem = CalculatorButtonOperationItem(value: .clear)
        items.append(clearItem)
    }
    
    func setValute(_ valute: [XMLCurrency]) {
        self.valute = valute
        
        let ruble = XMLCurrency(numCode: "None",
                                charCode: "RUB",
                                nominal: 1,
                                name: NSLocalizedString("Russian ruble", comment: "RUB currency name"),
                                value: 1.0)
        self.valute.insert(ruble, at: 0)
        
        let currentRegionCode = Locale.current.currencyCode ?? Config.StringConsts.defaultFirstCurrency
        
        let firstSelectedIndex = self.valute.firstIndex(where: { $0.charCode ==
            currentRegionCode
        }) ?? 0
        let secondSelectedIndex = self.valute.firstIndex(where: { $0.charCode ==
            Config.StringConsts.defaultSecondCurrency
        }) ?? 0
        
        firstSelectedCurrency = self.valute[firstSelectedIndex]
        secondSelectedCurrency = self.valute[secondSelectedIndex]
        
    }
}
