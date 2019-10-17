//
//  CalculatorMathematicalOperations.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 17.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

// MARK: Математические операции
internal extension CalculatorImplementation {
    
    /// Сложение
    func plus(left: Decimal, right: Decimal) throws -> Decimal {
        
        let result = left + right
        
        if result >= pow(10, Config.NumberPresentation.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    /// Вычитание
    func minus(left: Decimal, right: Decimal) throws -> Decimal {
        
        let result = left - right
        
        if result >= pow(10, Config.NumberPresentation.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    /// Умножение
    func multiply(left: Decimal, right: Decimal) throws -> Decimal {
        
        let result = left * right
        
        if result >= pow(10, Config.NumberPresentation.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    /// Деление
    func divide(left: Decimal, right: Decimal) throws -> Decimal {
        
        if right == 0 {
            throw CalculatorError.divideByZero
        }
        
        let result = left / right
        
        if result >= pow(10, Config.NumberPresentation.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    /// Возведение в степерь
    func power(left: Decimal, right: Decimal) throws -> Decimal {
        /*
         Если doubleResult = 1.8446744073709552e+19
         То Decimal(floatLiteral: doubleResult) Error WTF?
         */
        
        // Случай целых чисел
        if right.rounded(0, .plain) == right {
            let nsDecimalRight = NSDecimalNumber(decimal: right)
            let nsDecimalResult = pow(left, Int(truncating: nsDecimalRight))
            if nsDecimalResult >= pow(10, Config.NumberPresentation.MaximumDigits.showingInteger) {
                throw CalculatorError.greaterThenMax
            }
            return nsDecimalResult
        }
        
        let doubleResult = pow(Double(truncating: left as NSNumber), Double(truncating: right as NSNumber))
        
        if !doubleResult.isFinite {
            throw CalculatorError.nanValue
        }
        
        if doubleResult >= pow(10.0, Double(Config.NumberPresentation.MaximumDigits.showingInteger)) {
            throw CalculatorError.greaterThenMax
        }
        
        let result: Decimal = Decimal(floatLiteral: doubleResult)
        
        return result
    }
    
    /// Квадратный корень
    func squareTongue(value: Decimal) throws -> Decimal {
        do {
            let result = try power(left: value, right: 0.5)
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Логарифм
    func logarithm(value: Decimal) throws -> Decimal {
        
        let doubleResult = log(Double(truncating: value as NSNumber))
        
        if !doubleResult.isFinite {
            throw CalculatorError.nanValue
        }
        
        if doubleResult >= pow(10.0, Double(Config.NumberPresentation.MaximumDigits.showingInteger)) {
            throw CalculatorError.greaterThenMax
        }
        
        let result: Decimal = Decimal(floatLiteral: doubleResult)
        
        return result
    }
    
    /// Синус
    func sinus(value: Decimal) throws -> Decimal {
        do {
            let result = try trigonometric(value: value, function: sin)
            return result
        } catch {
            throw error
        }
    }
    
    /// Косинус
    func cosinus(value: Decimal) throws -> Decimal {
        do {
            let result = try trigonometric(value: value, function: cos)
            return result
        } catch {
            throw error
        }
    }
    
    /// Тангенс
    func tangent(value: Decimal) throws -> Decimal {
        
        do {
            let sin = try sinus(value: value)
            let cos = try cosinus(value: value)
            
            let result = try divide(left: sin, right: cos)
            
            return result
            
        } catch {
            throw error
        }
    }
    
    /// Тригонометрическая
    private func trigonometric(value: Decimal, function: (Double) -> Double) throws -> Decimal {
        
        do {
            var doubleResult: Double
            
            switch mode {
            case .deg:
                doubleResult = function((Double(truncating: value as NSNumber)*Double.pi)/180)
                
            case .rad:
                doubleResult = function(Double(truncating: value as NSNumber))
            }
            
            if !doubleResult.isFinite {
                throw CalculatorError.nanValue
            }
            
            if doubleResult >= pow(10.0, Double(Config.NumberPresentation.MaximumDigits.showingInteger)) {
                throw CalculatorError.greaterThenMax
            }
            
            let result: Decimal = Decimal(floatLiteral: doubleResult)
            
            return result.rounded(10, .plain)
        }
            
        catch {
            throw error
        }
    }
}
