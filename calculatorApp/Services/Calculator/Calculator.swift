//
//  Calculator.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/**
 Ошибки калькулятора
 
 *Values*
 `greaterThenMax` - Превышение максмального числа
 `divideByZero` - Деление на ноль
 `nanValue` - Нечисловой результат
 `noSecondOperand` - Отсутствует запомненное значение
 */
enum CalculatorError: Error {
    case greaterThenMax
    case divideByZero
    case nanValue
    case noSecondOperand
}

/**
 Делегат Calculator
 
 `calculatorDidUpdateStrValue` - действие обработано
 `calculatorDidSelectNewMode` - выбор нового режима
 `calculatorDidSelectNewOperation` - выбор новой операции
 */
protocol CalculatorDelegate: class {
    func calculator(_ calculator: Calculator, didUpdate strValue: String)
    func calculator(_ calculator: Calculator, didSelect newMode: RoundButtonModeValue)
    func calculator(_ calculator: Calculator, didSelect operation: RoundButtonOperationItem?)
}

/**
 Сервис калькулятора
 
 *Variables*
 
 `strValue` - Текущее строковое значение
 
 `currentValue` - Текущее числовое значение
 
 `mode` - Текущий режим
 
 `delegate` - Делегат
 
 *Functions*
 
 `handleAction` - Обработка нажатия круглой кнопки
 
 `removeLast` - Обработка удаления последнего символа
 */
protocol Calculator {
    var strValue: String { get }
    var currentValue: Decimal { get }
    var mode: RoundButtonModeValue { get }
    var delegate: CalculatorDelegate? { get set }
    
    func handleAction(of item: RoundButtonItem)
    func removeLast()
}

/// Реализация протокола `Calculator`
final class CalculatorImplementation: Calculator {
    
    /// Текущая выбранная операция
    private var currentOperation: RoundButtonOperationItem? = nil {
        didSet {
            delegate?.calculator(self, didSelect: currentOperation)
        }
    }
    /// Запомненное значение
    private var rememberedValue: Decimal? = nil
    
    /// Флаг для отслеживания действий после выполнения операции
    private var afterExecute: Bool = false {
        didSet {
            guard afterExecute else { return }
            readyToInsertNewNumber = true
        }
    }
    /// Флаг, определяющий начало ввода нового числа
    private var readyToInsertNewNumber: Bool = true
    
    /// Сбросить вспомогательные переменные
    private func resetVars() {
        rememberedValue = nil
        currentOperation = nil
        readyToInsertNewNumber = true
        afterExecute = false
    }
    
    /// Действия при получении ошибки
    private func didGotError() {
        clear()
        strValue = Config.Localization.error
    }
    
    // MARK: Calculator
    /// Текущее строковое значение
    var strValue: String = Config.NumberPresentation.strResultDefault {
        didSet {
            delegate?.calculator(self, didUpdate: strValue)
        }
    }
    
    /// Текущее числовое значение
    var currentValue: Decimal {
        get {
            return Decimal(string: strValue) ?? Decimal(string: Config.NumberPresentation.strResultDefault)!
        }
    }
    
    /// Текущий режим
    var mode: RoundButtonModeValue = Config.Calculator.defaultMode {
        didSet {
            delegate?.calculator(self, didSelect: mode)
        }
    }
    
    weak var delegate: CalculatorDelegate?
    
    /// Обработка нажатия круглой кнопки
    func handleAction(of item: RoundButtonItem) {
        switch item.type {
        // Нажата числовая кнопка
        case .number:
            guard let numberItem = item as? RoundButtonNumberItem else { return }
            
            // Если начинаем вводить новое число после =, то очистить выбранную операцию
            if afterExecute {
                currentOperation = nil
                afterExecute = false
            }
            
            // Если начинаем вводить новое число, то обнулить текущее значение
            if readyToInsertNewNumber {
                strValue = Config.NumberPresentation.strResultDefault
                readyToInsertNewNumber = false
            }
            
            switch numberItem.value {
            // Нажата кнопка с цифрой
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                // Вводится целая часть
                if !strValue.contains(RoundButtonNumericValue.dot.rawValue) {
                    // Если текущее число 0, то использовать новое число как первое
                    if currentValue == 0.0 {
                        strValue = numberItem.value.rawValue
                        
                        // Если текущее число не 0
                    } else {
                        //Если количество разрядов не превышено
                        if strValue.count < Config.NumberPresentation.MaximumDigits.defaultInteger {
                            strValue.append(numberItem.value.rawValue)
                        }
                    }
                    // Вводится дробная часть
                } else {
                    // Подсчитать количество дробных разрядов
                    guard let indexOfDot = strValue.firstIndex(of: RoundButtonNumericValue.dot.rawValue.first!) else { return }
                    let fractionPart = strValue.suffix(from: indexOfDot)
                    // Если количество дробных разрядов не превышено
                    if fractionPart.count - 1 < Config.NumberPresentation.MaximumDigits.defaultFraction {
                        strValue.append(numberItem.value.rawValue)
                    }
                }
            // Нажата кнопка с точкой
            case .dot:
                if !strValue.contains(RoundButtonNumericValue.dot.rawValue) {
                    strValue.append(numberItem.value.rawValue)
                }
            // Нажата кнопка с числом пи
            case .pi:
                let piNum = Double.pi
                strValue = String(piNum)
            }
            
        // Нажата кнопка операции
        case .operation:
            guard let operationItem = item as? RoundButtonOperationItem else { return }
            
            switch operationItem.value {
            // Операции, требующие два операнда
            case .plus, .minus, .multiplication, .division, .power:
                afterExecute = false
                readyToInsertNewNumber = true
                
                operationItem.selected = true
                
                // Запомнить операцию и значение
                rememberedValue = currentValue
                currentOperation = operationItem
                
            // Операции, требующие один операнд
            case .sqrt, .sin, .cos, .tan, .log:
                afterExecute = true
                readyToInsertNewNumber = true
                
                // Запомнить операцию и значение
                rememberedValue = currentValue
                currentOperation = operationItem
                
                guard let currentOperation = currentOperation else { return }
                
                do {
                    let newResult = try executeCurrentOperation(operation: currentOperation).rounded(Config.NumberPresentation.MaximumDigits.showingFraction, .plain)
                    let newStrResult = String(describing: newResult)
                    strValue = newStrResult
                } catch {
                    didGotError()
                    return
                }
            // Нажата кнопка "равно"
            case .execute:
                guard let currentOperation = currentOperation else { return }
                                
                do {
                    let newResult: Decimal
                    
                    // Если нажимать = сразу после вычисления, то повторить операцию для текущего значения
                    if afterExecute {
                        newResult = try doAgain(operation: currentOperation)
                            .rounded(Config.NumberPresentation.MaximumDigits.showingFraction, .plain)
                    } else {
                        newResult = try executeCurrentOperation(operation: currentOperation)
                            .rounded(Config.NumberPresentation.MaximumDigits.showingFraction, .plain)
                        
                        rememberedValue = currentValue
                        
                        afterExecute = true
                    }
                    let newStrResult = String(describing: newResult)
                    strValue = newStrResult
                    
                } catch {
                    didGotError()
                    return
                }
            // Нажата кнопка смены знака
            case .changeSign:
                if currentValue == 0.0 { return }
                
                if strValue.first! == "-" {
                    strValue.remove(at: strValue.startIndex)
                } else {
                    strValue = "-" + strValue
                }
            // Нажата кнопка "AC"
            case .clear:
                clear()
            }
            
        // Нажата кнопка режима
        case .mode:
            guard let modeItem = item as? RoundButtonModeItem else { return }
            mode = modeItem.value
            modeItem.selected = true
        }
    }
    
    /// Обработка удаления последнего символа
    func removeLast() {
        
        // Если текущее строковое значение не является числом, то ничего не менять
        guard Decimal(string: strValue) != nil else { return }
        
        // Ручное изменение числа после выполнения операции невозможно
        guard !afterExecute else { return }
        
        // Если число однозначеное, то сделать его нулем
        if strValue.count == 1 {
            strValue = Config.NumberPresentation.strResultDefault
            return
        }
        
        // Удаление последнего символа из числа
        strValue = String(strValue.dropLast())
    }
}

// MARK: Исполнители операций
extension CalculatorImplementation {
    
    /// Выполнение выбранной операции
    private func executeCurrentOperation(operation: RoundButtonOperationItem) throws -> Decimal {
        
        guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
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
                
            case .sqrt:
                result = try squareTongue(value: rememberedValue)
                
            case .log:
                result = try logarithm(value: rememberedValue)
                
            case .sin:
                result = try sinus(value: rememberedValue)
                
            case .cos:
                result = try cosinus(value: rememberedValue)
                
            case .tan:
                result = try tangent(value: rememberedValue)
                
            case .clear, .changeSign, .execute:
                return result
            }
        } catch {
            #if DEBUG
            print("GOT ERROR: \(error)")
            #endif
            throw error
        }
        
        return result
    }
    
    /// Повтор предыдущей операции
    private func doAgain(operation: RoundButtonOperationItem) throws -> Decimal {

        var result: Decimal = 0.0

        do {
            switch operation.value {
            case .plus:
                guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
                result = try plus(left: currentValue, right: rememberedValue)

            case .minus:
                guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
                result = try minus(left: currentValue, right: rememberedValue)

            case .multiplication:
                guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
                result = try multiply(left: currentValue, right: rememberedValue)

            case .division:
                guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
                result = try divide(left: currentValue, right: rememberedValue)

            case .power:
                guard let rememberedValue = rememberedValue else { throw CalculatorError.noSecondOperand }
                result = try power(left: currentValue, right: rememberedValue)

            case .sqrt:
                result = try squareTongue(value: currentValue)

            case .log:
                result = try logarithm(value: currentValue)

            case .sin:
                result = try sinus(value: currentValue)

            case .cos:
                result = try cosinus(value: currentValue)

            case .tan:
                result = try tangent(value: currentValue)

            case .clear, .changeSign, .execute:
                return result
            }
        } catch {
            #if DEBUG
            print("GOT ERROR: \(error)")
            #endif
            throw error
        }

        return result
    }
    
    /// Сброс калькулятора (значения и операции)
    private func clear() {
        strValue = Config.NumberPresentation.strResultDefault
        resetVars()
    }
}

// MARK: Другое
extension CalculatorImplementation {
    
    /// Печать числового и текстового значений в консоль
    private func logValuesIntoConsole() {
        #if DEBUG
        print("String: \(strValue)")
        print("Decimal: \(currentValue)\n")
        #endif
    }
}
