//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol CalculatorDelegate: class {
    func calculatorSelectedNewOperation(_ calculator: Calculator)
    func calculatorSelectedNewMode(_ calculator: Calculator)
}

protocol Calculator {
    
    var strResult: String { get }
    var currentValue: Double { get }
    var mode: CalculatorButtonModeValue { get }
    var delegate: CalculatorDelegate? { get set }
    
    func handleAction(of item: CalculatorButtonItem)
    func plus(left: Double, right: Double) -> Double
    func minus(left: Double, right: Double) -> Double
    func multiply(left: Double, right: Double) -> Double
    func divide(left: Double, right: Double) -> Double
    func doAgain(operation: CalculatorButtonOperationItem) -> Double
    func clear()
    func removeLast()
}

class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    private var appendingDecimalPartMode: Bool = false
    private var currentOperation: CalculatorButtonOperationItem? = nil
    private var rememberedValue: Double?
    private var readyToInsertNewNumber: Bool = true
    
    var strResult: String = Config.strResultDefault {
        didSet {
            guard let newResult = Double(strResult) else { fatalError() }
            currentValue = newResult
        }
    }
    
    var currentValue: Double = 0.0
    var mode: CalculatorButtonModeValue = .deg
    var rememberedNumber: Double?
    
    weak var delegate: CalculatorDelegate?
    
    private init() {}
    
    func handleAction(of item: CalculatorButtonItem) {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? CalculatorButtonNumberItem else { return }
            
            switch numberItem.value {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                if readyToInsertNewNumber {
                    strResult = "0"
                    readyToInsertNewNumber = false
                }
                
                if !appendingDecimalPartMode { //Если вводится целая часть
                    if currentValue == 0.0 { //Если начальное число 0, то использовать новое число как первое
                        strResult = numberItem.value.rawValue
                        
                    } else { //Если начальное число не 0
                        if strResult.count < Config.MaximumDigits.integer { //Если количество разрядов не превышено
                            strResult.append(numberItem.value.rawValue)
                        }
                    }
                    
                } else { // Если вводится дробная часть
                    guard let indexOfDot = strResult.firstIndex(of: CalculatorButtonNumericValue.dot.rawValue.first!) else { return }
                    let fractionPart = strResult.suffix(from: indexOfDot)
                    if fractionPart.count - 1 < Config.MaximumDigits.fraction { //Если количество дробных разрядов не превышено
                        strResult.append(numberItem.value.rawValue)
                    }
                }
                
            case .dot:
                if !appendingDecimalPartMode {
                    appendingDecimalPartMode = true
                    strResult.append(numberItem.value.rawValue)
                }
            }
            
        case .operation:
            guard let operationItem = item as? CalculatorButtonOperationItem else { return }
            
            switch operationItem.value {
            case .plus, .minus, .multiplication, .division, .exp, .sin, .cos, .tan, .log:
                
                if let delegate = delegate {
                    delegate.calculatorSelectedNewOperation(self)
                }
                
                rememberedValue = currentValue
                currentOperation = operationItem
                operationItem.selected = true
                readyToInsertNewNumber = true
                
            case .execute:
                
                guard let currentOperation = currentOperation else { return }
                
                if let delegate = delegate {
                    delegate.calculatorSelectedNewOperation(self)
                }
                
                if readyToInsertNewNumber {
                    let newResult = doAgain(operation: currentOperation)
                    strResult = String(newResult)
                } else {
                    let newResult = executeCurrentOperation(operation: currentOperation)
                    rememberedValue = currentValue
                    readyToInsertNewNumber = true
                    strResult = String(newResult)
                }
                
            case .clear:
                clear()
            }
            
        case .mode:
            guard let modeItem = item as? CalculatorButtonModeItem else { return }
            
            if let delegate = delegate {
                delegate.calculatorSelectedNewMode(self)
            }
            
            switch modeItem.value {
            case .deg:
                mode = .deg
            case .rad:
                mode = .rad
            }
            
            modeItem.selected = true
        }
    }
    
    private func executeCurrentOperation(operation: CalculatorButtonOperationItem) -> Double {
        
        guard let rememberedValue = rememberedValue else { return 0.0 }
        var result: Double = 0.0
        
        switch operation.value {
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
    
    func doAgain(operation: CalculatorButtonOperationItem) -> Double {
        
        var result: Double = 0.0
        
        switch operation.value {
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
            return result
        }
        
        return result
    }
    
    func clear() {
        
        if let delegate = delegate {
            delegate.calculatorSelectedNewOperation(self)
        }
        
        rememberedValue = nil
        currentOperation = nil
        strResult = Config.strResultDefault
        appendingDecimalPartMode = false
        readyToInsertNewNumber = true
    }
    
    func removeLast() {
        if strResult.last == CalculatorButtonNumericValue.dot.rawValue.first {
            strResult = String(strResult.dropLast())
            appendingDecimalPartMode = false
            return
        }
        
        if strResult.count == 1 {
            strResult = Config.strResultDefault
            return
        }
        
        strResult = String(strResult.dropLast())
    }
}
