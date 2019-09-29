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
}

class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    var userResult: Double = 0.0
    var lastInsertedNumber: Double = 1.0
    var history: [(Double) -> Double] = []
    
    private init() {}
    
    // MARK: Calculator protocol
    @discardableResult func plus(value: Double) -> Double {
        
        history.append(plus(value:))
        lastInsertedNumber = value
        
        userResult += value
        
        return userResult
    }
    
    @discardableResult func minus(value: Double) -> Double {
        
        history.append(minus(value:))
        lastInsertedNumber = value
        
        userResult -= value
        
        return userResult
    }
    
    @discardableResult func multiply(value: Double) -> Double {
        
        history.append(multiply(value:))
        lastInsertedNumber = value
        
        userResult *= value
        
        return userResult
    }
    
    @discardableResult func divide(value: Double) -> Double {
        
        guard value != 0.0 else { return userResult }
        
        history.append(divide(value:))
        lastInsertedNumber = value
        
        userResult /= value
        
        return userResult
    }
    
    @discardableResult func doAgain() -> Double {
        
        guard let lastFunc = history.last else { return userResult }
        
        userResult = lastFunc(lastInsertedNumber)
        
        return userResult
    }
}
