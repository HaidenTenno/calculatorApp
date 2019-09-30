//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

enum CalculatorMode: String {
    case deg = "Deg"
    case rad = "Rad"
}

protocol Calculator {
    
    var strResult: String { get }
    var currentValue: Double { get }
    var mode: CalculatorMode { get set }
    
    func handleAction(of item: CalculatorCollectionViewCell)
    func plus(left: Double, right: Double) -> Double
    func minus(left: Double, right: Double) -> Double
    func multiply(left: Double, right: Double) -> Double
    func divide(left: Double, right: Double) -> Double
    func doAgain(operation: CalculatorButtonValue) -> Double
    func clear()
    func removeLast()
}

class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    private var appendingDecimalPartMode: Bool = false
    private var currentOperation: CalculatorButtonValue? = nil
    private var rememberedValue: Double?
    private var readyToInsertNewNumber: Bool = true
    
    var strResult: String = "0" {
        didSet {
            guard let newResult = Double(strResult) else { fatalError() }
            currentValue = newResult
            
//            print("Current: \(currentValue)")
//            print("Remembered: \(rememberedValue)")
//            print("String: \(strResult)")
        }
    }
    
    var currentValue: Double = 0.0
    var mode: CalculatorMode = .deg
    var rememberedNumber: Double?
    
    private init() {}
    
    func handleAction(of item: CalculatorCollectionViewCell) {
        
        switch item.calculatorButtonValue {
        //Ввод числа
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
            
            if readyToInsertNewNumber {
                strResult = "0"
                readyToInsertNewNumber = false
            }
            
            if !appendingDecimalPartMode { //Если вводится целая часть
                if currentValue == 0.0 { //Если начальное число 0, то использовать новое число как первое
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
            
        //Ввод точки (начало ввода дробной части)
        case .dot:
            if !appendingDecimalPartMode {
                appendingDecimalPartMode = true
                strResult.append(item.calculatorButtonValue.rawValue)
            }
            
        case .clear:
            clear()
            
        case .plus, .minus, .multiplication, .division, .exp, .sin, .cos, .tan, .log:
            
            print(item.calculatorButtonValue.rawValue)
            
            rememberedValue = currentValue
            currentOperation = item.calculatorButtonValue
            readyToInsertNewNumber = true
            
        case .execute:
            
            if readyToInsertNewNumber {
                let newResult = doAgain(operation: currentOperation!)
                strResult = String(newResult)
            } else {
                guard let currentOperation = currentOperation else { return }
                let newResult = executeCurrentOperation(operation: currentOperation)
                rememberedValue = currentValue
                readyToInsertNewNumber = true
                
                strResult = String(newResult)
            }
            
        case .deg:
            mode = .deg
            
        case .rad:
            mode = .rad
            
        case .none:
            fatalError()
        }
    }
    
    private func executeCurrentOperation(operation: CalculatorButtonValue) -> Double {
        
        guard let rememberedValue = rememberedValue else { return 0.0 }
        var result: Double = 0.0
        
        switch operation {
        case .plus:
            result = plus(left: rememberedValue, right: currentValue)
            
        case .minus:
            result = minus(left: rememberedValue, right: currentValue)
            
        case .multiplication:
            result = multiply(left: rememberedValue, right: currentValue)
            
        case .division:
            result = divide(left: rememberedValue, right: currentValue)
            
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
            
        default:
            print("Not implemented")
        }
        
        return result
    }
    
    func plus(left: Double, right: Double) -> Double {
        
        return left + right
    }
    
    func minus(left: Double, right: Double) -> Double {
        
        return left - right
    }
    
    func multiply(left: Double, right: Double) -> Double {
        
        return left * right
    }
    
    func divide(left: Double, right: Double) -> Double {
        
        return left / right
    }
    
    func doAgain(operation: CalculatorButtonValue) -> Double {
        
        var result: Double = 0.0
        
        switch operation {
        case .plus:
            result = plus(left: currentValue, right: rememberedValue!)
            
        case .minus:
            result = minus(left: currentValue, right: rememberedValue!)
            
        case .multiplication:
            result = multiply(left: currentValue, right: rememberedValue!)
            
        case .division:
            result = divide(left: currentValue, right: rememberedValue!)
            
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
            
        default:
            print("Not implemented")
        }
        
        return result
    }
    
    func clear() {
        
        rememberedValue = nil
        currentOperation = nil
        strResult = "0"
        appendingDecimalPartMode = false
        readyToInsertNewNumber = true
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
