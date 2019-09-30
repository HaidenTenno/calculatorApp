//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol Calculator {
    
    var strResult: String { get }
    var userResult: Double { get }
    
    func handleAction(of item: CalculatorCollectionViewCell)
    func plus(value: Double) -> Double
    func minus(value: Double) -> Double
    func multiply(value: Double) -> Double
    func divide(value: Double) -> Double
    func doAgain() -> Double
    func clear()
    func removeLast()
}

class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    private var appendingDecimalPartMode: Bool = false
    private var currentOperation: CalculatorButtonValue? = nil
    
    var strResult: String = "0" {
        didSet {
            guard let newResult = Double(strResult) else { fatalError() }
            userResult = newResult
            
//            print("Double: \(userResult)")
//            print("String: \(strResult)")
        }
    }
    
    var userResult: Double = 0.0
    var rememberedNumber: Double?
    var history: [(Double) -> Double] = []
    
    private init() {}
    
    // MARK: Calculator protocol
    func handleAction(of item: CalculatorCollectionViewCell) {
        
        switch item.calculatorButtonValue {
        //Ввод числа
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            if currentOperation == nil { //Если не выбрана ни одна операция
                if !appendingDecimalPartMode { //Если вводится целая часть
                    if userResult == 0.0 { //Если начальное число 0, то использовать новое число как первое
                        strResult = item.calculatorButtonValue.rawValue
                        
                    } else { //Если начальное число не 0
                        if strResult.count < Config.MaximumDigits.integer { //Если количество разрядов не превышено
                            strResult.append(item.calculatorButtonValue.rawValue)
                        }
                    }
                    
                } else { // Если вводится дробная часть
                    guard let indexOfDot = strResult.firstIndex(of: CalculatorButtonValue.dot.rawValue.first!) else { return }
                    let fractionPart = strResult.suffix(from: indexOfDot)
                    if fractionPart.count - 1 < Config.MaximumDigits.fraction { //Если количество дробных разрядов не превышено
                        strResult.append(item.calculatorButtonValue.rawValue)
                    }
                }
                
            } else { //Если была выбрана операция
                print("Not implemented")
            }
            
        //Ввод точки (начало ввода дробной части)
        case .dot:
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
        strResult = "0"
        appendingDecimalPartMode = false
    }
    
    func removeLast() {
        
        if strResult.last == CalculatorButtonValue.dot.rawValue.first {
            strResult = String(strResult.dropLast())
            appendingDecimalPartMode = false
            return
        }
        
        if strResult.count == 1 {
            strResult = "0"
            return
        }
        
        strResult = String(strResult.dropLast())
    }
}
