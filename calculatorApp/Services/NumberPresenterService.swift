//
//  NumberPresenterService.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 09.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

enum NumberPresenterServiceStyle {
    case calculator
    case converter
}

final class NumberPresenterService {
    
    private let formatter: NumberFormatter
    
    init(style: NumberPresenterServiceStyle) {
        let formatter = NumberFormatter()
        formatter.alwaysShowsDecimalSeparator = false
        formatter.decimalSeparator = CalculatorButtonNumericValue.dot.rawValue
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = " "
        formatter.groupingSize = 3
        formatter.numberStyle = .decimal
        
        switch style {
        case .calculator:
            formatter.maximumIntegerDigits = Config.NumberPresentation.MaximumDigits.showingInteger
            formatter.maximumFractionDigits = Config.NumberPresentation.MaximumDigits.showingFraction
        case .converter:
            formatter.maximumIntegerDigits = Config.NumberPresentation.MaximumDigits.defaultIntegerConv
            formatter.maximumFractionDigits = Config.NumberPresentation.MaximumDigits.defaultFractionConv
        }
        self.formatter = formatter
    }
    
    func format(string: String) -> String {
                
        var result = string
        
        result = formatDecimal(string: string)
        
        return result
    }
    
    private func formatDecimal(string: String) -> String {
        
        var result = string
        let decimalResult = Decimal(string: result)
        
        guard let nsNumberResult = decimalResult as NSNumber? else { return result }
        
        if result.last == CalculatorButtonNumericValue.dot.rawValue.first {
            formatter.alwaysShowsDecimalSeparator = false
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
            result.append(CalculatorButtonNumericValue.dot.rawValue)
            
        } else if result.contains(CalculatorButtonNumericValue.dot.rawValue) {
            formatter.alwaysShowsDecimalSeparator = true
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
            
            if string.last == CalculatorButtonNumericValue.zero.rawValue.first {
                let arrayOfStrings = Array(string)
                for element in arrayOfStrings.reversed() {
                    if element == CalculatorButtonNumericValue.zero.rawValue.first {
                        result.append(CalculatorButtonNumericValue.zero.rawValue)
                    } else {
                        break
                    }
                }
            }
            
        } else {
            formatter.alwaysShowsDecimalSeparator = false
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
        }
        
        return result
    }
}
