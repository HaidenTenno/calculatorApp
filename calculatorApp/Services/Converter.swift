//
//  Converter.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol Converter {
    
    var firstStrResult: String { get }
    var secondStrResult: String { get }
    var firstNumericResult: Decimal { get }
    var secondNumericResult: Decimal { get }
    
    func handleAction(of item: CalculatorButtonItem)
    func swapCurrency()
    func removeLast()
}

final class ConverterImplementation: Converter {
    
    static let shared = ConverterImplementation()
    
    private var readyToInsertNewNumber: Bool = true
    
    var firstStrResult: String = Config.strResultDefault {
        didSet {
            guard let newResult = Decimal(string: firstStrResult) else { return }
            firstNumericResult = newResult
        }
    }
    var secondStrResult: String = Config.strResultDefault
    var firstNumericResult: Decimal = Decimal(string: Config.strResultDefault)!
    var secondNumericResult: Decimal = Decimal(string: Config.strResultDefault)!
    
    private init() {}
    
    func handleAction(of item: CalculatorButtonItem) {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? CalculatorButtonNumberItem else { return }
            
            switch numberItem.value {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:

                if readyToInsertNewNumber { //Если начинаем вводить новое число, то обнулить текущее значение
                    firstStrResult = Config.strResultDefault
                    readyToInsertNewNumber = false
                }
                
                if !firstStrResult.contains(CalculatorButtonNumericValue.dot.rawValue) {
                    if firstNumericResult == 0.0 {
                        firstStrResult = numberItem.value.rawValue

                    } else {
                        if firstStrResult.count < Config.MaximumDigits.defaultIntegerConv {
                            firstStrResult.append(numberItem.value.rawValue)
                        }
                    }
                } else {
                    guard let indexOfDot = firstStrResult.firstIndex(of: CalculatorButtonNumericValue.dot.rawValue.first!) else { return }
                    let fractionPart = firstStrResult.suffix(from: indexOfDot)
                    if fractionPart.count - 1 < Config.MaximumDigits.defaultFractionConv {
                        firstStrResult.append(numberItem.value.rawValue)
                    }
                }
                
            case .dot:
                
                if readyToInsertNewNumber { //Если начинаем вводить новое число, то обнулить текущее значение
                    firstStrResult = Config.strResultDefault
                }
                
                if !firstStrResult.contains(CalculatorButtonNumericValue.dot.rawValue) {
                    readyToInsertNewNumber = false
                    firstStrResult.append(numberItem.value.rawValue)
                }

            default:
                return
            }
            
        case .operation:
            guard let operationItem = item as? CalculatorButtonOperationItem else { return }
            guard  operationItem.value == .clear else { return }
            clear()
            
        default:
            return
        }
    }
    
    func swapCurrency() {
        print("Not implemented")
    }
    
    private func clear() {
        
        readyToInsertNewNumber = true
        firstStrResult = Config.strResultDefault
    }
    
    func removeLast() {
        
        if firstStrResult.count == 1 || (firstStrResult.count == 2 && firstNumericResult == 0) {
            firstStrResult = Config.strResultDefault
            return
        }
        
        firstStrResult = String(firstStrResult.dropLast())
    }
}
