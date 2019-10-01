//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

enum CalculatorError: Error {
    case greaterThenMax
    case divideByZero
    case nanValue
}

protocol CalculatorDelegate: class {
    func calculatorSelectedNewOperation(_ calculator: Calculator)
    func calculatorSelectedNewMode(_ calculator: Calculator)
}

protocol Calculator {
    
    var strValue: String { get }
    var currentValue: Decimal { get }
    var mode: CalculatorButtonModeValue { get }
    var delegate: CalculatorDelegate? { get set }
    
    func handleAction(of item: CalculatorButtonItem)
    func removeLast()
}

final class CalculatorImplementation: Calculator {
    
    static let shared = CalculatorImplementation()
    
    private var currentOperation: CalculatorButtonOperationItem? = nil
    private var rememberedValue: Decimal? = nil
    private var afterExecute: Bool = false
    private var readyToInsertNewNumber: Bool = true
    
    private var calculatorError: Bool = false {
        didSet {
            if calculatorError {
                strValue = "Ошибка"

                if let delegate = delegate {
                    delegate.calculatorSelectedNewOperation(self)
                }
                
                currentValue = Decimal(string: Config.strResultDefault)!
                rememberedValue = nil
                currentOperation = nil
                readyToInsertNewNumber = true
            }
        }
    }
    
    var strValue: String = Config.strResultDefault {
        didSet {
            if calculatorError {
                return
            }
            
            guard let newResult = Decimal(string: strValue) else {
                calculatorError = true
                return
            }
            currentValue = newResult
            
            #if DEBUG
            print("Dicemal: \(currentValue)")
            print("String: \(strValue)")
            #endif
        }
    }
    
    var currentValue: Decimal = Decimal(string: Config.strResultDefault)!
    var mode: CalculatorButtonModeValue = .deg
    
    weak var delegate: CalculatorDelegate?
    
    private init() {}
    
    //Обработка нажатия кнопки
    func handleAction(of item: CalculatorButtonItem) {
        
        if calculatorError {
            clear()
        }
        
        switch item.type {
        case .number:
            guard let numberItem = item as? CalculatorButtonNumberItem else { return }
            
            if afterExecute { //Если начинаем вводить новое число после =, то очистить выбранную операцию
                currentOperation = nil
                afterExecute = false
            }
            
            switch numberItem.value {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                
                if readyToInsertNewNumber { //Если начинаем вводить новое число, то обнулить текущее значение
                    strValue = Config.strResultDefault
                    readyToInsertNewNumber = false
                }
                
                if !strValue.contains(CalculatorButtonNumericValue.dot.rawValue) { //Если вводится целая часть
                    if currentValue == 0.0 { //Если начальное число 0, то использовать новое число как первое
                        strValue = numberItem.value.rawValue
                        
                    } else { //Если начальное число не 0
                        if strValue.count < Config.MaximumDigits.defaultInteger { //Если количество разрядов не превышено
                            strValue.append(numberItem.value.rawValue)
                        }
                    }
                    
                } else { // Если вводится дробная часть
                    guard let indexOfDot = strValue.firstIndex(of: CalculatorButtonNumericValue.dot.rawValue.first!) else { return }
                    let fractionPart = strValue.suffix(from: indexOfDot)
                    if fractionPart.count - 1 < Config.MaximumDigits.defaultFraction { //Если количество дробных разрядов не превышено
                        strValue.append(numberItem.value.rawValue)
                    }
                }
                
            case .dot:
                
                if afterExecute { //Если начинаем вводить новое число после =, то очистить выбранную операцию
                    currentOperation = nil
                    afterExecute = false
                }
                
                if readyToInsertNewNumber { //Если начинаем вводить новое число, то обнулить текущее значение
                    strValue = Config.strResultDefault
                }

                if !strValue.contains(CalculatorButtonNumericValue.dot.rawValue) {
                    readyToInsertNewNumber = false
                    strValue.append(numberItem.value.rawValue)
                }
            }
            
        case .operation:
            guard let operationItem = item as? CalculatorButtonOperationItem else { return }
            
            switch operationItem.value {
            case .plus, .minus, .multiplication, .division, .power, .sin, .cos, .tan, .log:
                
                if let delegate = delegate { //Для сброса выбранной операции
                    delegate.calculatorSelectedNewOperation(self)
                }
                
                rememberedValue = currentValue //Запомнить текущее значение
                currentOperation = operationItem //Запомнить новую операцию
                afterExecute = false
                operationItem.selected = true //Для выделения кнопки
                readyToInsertNewNumber = true //Режим ввода нового числа
                
            case .execute:
                
                guard let currentOperation = currentOperation else { return }
                
                if let delegate = delegate { //Для сброса выбранной операции
                    delegate.calculatorSelectedNewOperation(self)
                }
                
                let newResult: Decimal
                
                do {
                    if readyToInsertNewNumber { //Если нажимать = сразу после вычисления, то повторить операцию для нового значения
                        newResult = try doAgain(operation: currentOperation).rounded(Config.MaximumDigits.showingFraction, .up)
                    } else {
                        newResult = try executeCurrentOperation(operation: currentOperation).rounded(Config.MaximumDigits.showingFraction, .up)
                        rememberedValue = currentValue
                        readyToInsertNewNumber = true
                    }
                    
                } catch {
                    calculatorError = true
                    return
                }
                
                let newStrResult = String(describing: newResult)
                
                afterExecute = true
                
                strValue = newStrResult
            
            case .changeSign:
                
                if strValue == Config.strResultDefault {
                    return
                }
                
                if strValue.first! == "-" {
                    strValue.remove(at: strValue.startIndex)
                } else {
                    strValue = "-" + strValue
                }
                
            case .clear:
                clear()
            }
            
        case .mode:
            guard let modeItem = item as? CalculatorButtonModeItem else { return }
            
            if let delegate = delegate { //Для сброса выбранного режима
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
    
    //Выполнить выбранную операцию
    private func executeCurrentOperation(operation: CalculatorButtonOperationItem) throws -> Decimal {
        
        guard let rememberedValue = rememberedValue else { return 0.0 }
        var result: Decimal = 0.0
        
        do {
            switch operation.value {
            case .plus:
                result = try plus(left: rememberedValue, right: currentValue)
                
            case .minus:
                result = try minus(left: rememberedValue, right: currentValue)
                
            case .multiplication:
                result = try multiply(left: rememberedValue, right: currentValue)
                
            case .division:
                result = try divide(left: rememberedValue, right: currentValue)
                
            case .power:
                result = try power(left: rememberedValue, right: currentValue)
                
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
        } catch {
            throw error
        }
        
        return result
    }
    
    //Сложение
    private func plus(left: Decimal, right: Decimal) throws -> Decimal {
        
        let result = left + right
        
        if result >= pow(10, Config.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    //Вычитание
    private func minus(left: Decimal, right: Decimal) throws -> Decimal {
        
        let result = left - right
        
        if result >= pow(10, Config.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    //Умножение
    private func multiply(left: Decimal, right: Decimal) throws -> Decimal {
                
        let result = left * right
        
        if result >= pow(10, Config.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    //Деление
    private func divide(left: Decimal, right: Decimal) throws -> Decimal {
        
        if right == 0 {
            throw CalculatorError.divideByZero
        }
        
        let result = left / right
        
        if result >= pow(10, Config.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
        
        return result
    }
    
    //Возведение в степерь
    private func power(left: Decimal, right: Decimal) throws -> Decimal {

        let doubleResult = pow(Double(truncating: left as NSNumber), Double(truncating: right as NSNumber))
        
        if !doubleResult.isFinite {
            throw CalculatorError.nanValue
        }
        
        let result = Decimal(floatLiteral: doubleResult)
        
        if result >= pow(10, Config.MaximumDigits.showingInteger) {
            throw CalculatorError.greaterThenMax
        }
                
        return result
    }
    
    //Повтор предыдущей операции
    private func doAgain(operation: CalculatorButtonOperationItem) throws -> Decimal {
        
        guard let rememberedValue = rememberedValue else { return 0.0 }
        var result: Decimal = 0.0
        
        do {
            switch operation.value {
            case .plus:
                result = try plus(left: currentValue, right: rememberedValue)
                
            case .minus:
                result = try minus(left: currentValue, right: rememberedValue)
                
            case .multiplication:
                result = try multiply(left: currentValue, right: rememberedValue)
                
            case .division:
                result = try divide(left: currentValue, right: rememberedValue)
                
            case .power:
                result = try power(left: currentValue, right: rememberedValue)
                
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
        } catch {
            throw error
        }
        
        return result
    }
    
    //Сброс
    private func clear() {
        
        if let delegate = delegate {
            delegate.calculatorSelectedNewOperation(self)
        }
        
        strValue = Config.strResultDefault
        
        rememberedValue = nil
        currentOperation = nil
        readyToInsertNewNumber = true
        calculatorError = false
    }
    
    //Назад
    func removeLast() {
        
        if calculatorError {
            calculatorError = false
            strValue = Config.strResultDefault
            return
        }
        
        if strValue.count == 1 || (strValue.count == 2 && currentValue < 0) {
            strValue = Config.strResultDefault
            return
        }
        
        strValue = String(strValue.dropLast())
    }
}
