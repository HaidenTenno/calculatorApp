//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol Calculator {
    func plus(value: Double) -> Double
    func minus(value: Double) -> Double
    func multiply(value: Double) -> Double
    func divide(value: Double) -> Double
    func doAgain() -> Double
    func clear()
}

class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    private var appendingDecimalPartMode: Bool = false
    private var currentOperation: CalculatorButtonValue? = nil
    
    private var formatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.decimalSeparator = ","
        numberFormatter.alwaysShowsDecimalSeparator = false
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }
    
    var userResult: Double = 0.0
    var strResult: String = "0" {
        didSet {
            guard let newResult = formatter.number(from: strResult) as? Double else { fatalError() }
            userResult = newResult
        }
    }
    var rememberedNumber: Double?
    var history: [(Double) -> Double] = []
    
    private init() {}
    
    func handleAction(of item: CalculatorCollectionViewCell) {
        
        switch item.calculatorButtonValue {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            if currentOperation == nil {
                if !appendingDecimalPartMode {
                    if userResult == 0.0 {
                        strResult = item.calculatorButtonValue.rawValue
                    } else {
                        strResult.append(item.calculatorButtonValue.rawValue)
                    }
                } else {
                    strResult.append(item.calculatorButtonValue.rawValue)
                }
            }
            
        case .comma:
            if !appendingDecimalPartMode {
                appendingDecimalPartMode = true
                strResult.append(item.calculatorButtonValue.rawValue)
            }
            
        case .clear:
            clear()
            
        case .plus:
            print("Not implemented")
            
        case .minus:
            print("Not implemented")
            
        case .multiplication:
            print("Not implemented")
            
        case .division:
            print("Not implemented")
            
        case .exp:
            print("Not implemented")
            
        case .sin:
            print("Not implemented")
            
        case .cos:
            print("Not implemented")
            
        case .tan:
            print("Not implemented")
            
        case .log:
            print("Not implemented")
            
        case .execute:
            print("Not implemented")
            
        case .none:
            fatalError()
        }
    }
    
    // MARK: Calculator protocol
    @discardableResult func plus(value: Double) -> Double {
        
        history.append(plus(value:))
        rememberedNumber = value
        
        userResult += value
        
        return userResult
    }
    
    @discardableResult func minus(value: Double) -> Double {
        
        history.append(minus(value:))
        rememberedNumber = value
        
        userResult -= value
        
        return userResult
    }
    
    @discardableResult func multiply(value: Double) -> Double {
        
        history.append(multiply(value:))
        rememberedNumber = value
        
        userResult *= value
        
        return userResult
    }
    
    @discardableResult func divide(value: Double) -> Double {
        
        guard value != 0.0 else { return userResult }
        
        history.append(divide(value:))
        rememberedNumber = value
        
        userResult /= value
        
        return userResult
    }
    
    @discardableResult func doAgain() -> Double {
        
        guard let lastFunc = history.last else { return userResult }
        guard let rememberedNumber = rememberedNumber else { return userResult }
        
        userResult = lastFunc(rememberedNumber)
        
        return userResult
    }
    
    func clear() {
        
        history.removeAll()
        userResult = 0.0
        strResult = "0"
        appendingDecimalPartMode = false
    }
}
