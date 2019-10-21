//
//  Converter.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/**
 Делегат Converter
 
 `converterDidUpdateStrValue` - действие обработано
 */
protocol ConverterDelegate: class {
    func converter(_ converter: Converter, didUpdate firsStrResult: String, _ secondStrResult: String)
}

/**
 Сервис конвертера
 
 *Variables*
 
 `firstCurrency` - Первая выбранная валюта
 
 `secondCurrency` - Вторая выбранная валюта
 
 `firstStrResult` - Первое строковое значение
 
 `secondStrResult` - Второе строковое значение
 
 `firstNumericResult` - Первое числовое значение
 
 `secondNumericResult` - Второе числовое значение
 
 *Functions*
 
 `handleAction` - Обработка нажатия круглой кнопки
 
 `removeLast` - Обработка удаления последнего символа
 */
protocol Converter {
    var firstCurrency: XMLCurrency? { get set }
    var secondCurrency: XMLCurrency? { get set }
    var firstStrResult: String { get }
    var secondStrResult: String { get }
    var firstNumericResult: Decimal { get }
    var secondNumericResult: Decimal { get }
    var delegate: ConverterDelegate? { get set }
    
    func handleAction(of item: RoundButtonItem)
    func removeLast()
}

/// Реализация протокола `Converter`
final class ConverterImplementation: Converter {
    
    /// Флаг, определяющий начало ввода нового числа
    private var readyToInsertNewNumber: Bool = true
    
    // MARK: Converter
    
    /// Первая выбранная валюта
    var firstCurrency: XMLCurrency? {
        didSet {
            secondNumericResult = calculateSecondNumericResult()
        }
    }
    /// Вторая выбранная валюта
    var secondCurrency: XMLCurrency? {
        didSet {
            secondNumericResult = calculateSecondNumericResult()
        }
    }
    
    // 1
    /// Первое строковое значение
    var firstStrResult: String = Config.NumberPresentation.strResultDefault {
        didSet {
            guard let newResult = Decimal(string: firstStrResult) else { return }
            firstNumericResult = newResult
        }
    }
    // 4
    /// Второе строковое значение
    var secondStrResult: String = Config.NumberPresentation.strResultDefault {
        didSet {
            delegate?.converter(self, didUpdate: firstStrResult, secondStrResult)
        }
    }
    
    // 2
    /// Первое числовое значение
    var firstNumericResult: Decimal = Decimal(string: Config.NumberPresentation.strResultDefault)! {
        didSet {
            secondNumericResult = calculateSecondNumericResult()
        }
    }
    // 3
    /// Второе числовое значение
    var secondNumericResult: Decimal = Decimal(string: Config.NumberPresentation.strResultDefault)! {
        didSet {
            secondStrResult = String(describing: secondNumericResult)
        }
    }
    
    weak var delegate: ConverterDelegate?
    
    /// Обработка нажатия круглой кнопки
    func handleAction(of item: RoundButtonItem) {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? RoundButtonNumberItem else { return }
            
            // Если начинаем вводить новое число, то обнулить текущее значение
            if readyToInsertNewNumber {
                firstStrResult = Config.NumberPresentation.strResultDefault
                readyToInsertNewNumber = false
            }
            
            switch numberItem.value {
            // Нажата кнопка с цифрой
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero:
                if !firstStrResult.contains(RoundButtonNumericValue.dot.rawValue) {
                    if firstNumericResult == 0.0 {
                        firstStrResult = numberItem.value.rawValue
                        
                    } else {
                        if firstStrResult.count < Config.NumberPresentation.MaximumDigits.defaultIntegerConv {
                            firstStrResult.append(numberItem.value.rawValue)
                        }
                    }
                } else {
                    guard let indexOfDot = firstStrResult.firstIndex(of: RoundButtonNumericValue.dot.rawValue.first!) else { return }
                    let fractionPart = firstStrResult.suffix(from: indexOfDot)
                    if fractionPart.count - 1 < Config.NumberPresentation.MaximumDigits.defaultFractionConv {
                        firstStrResult.append(numberItem.value.rawValue)
                    }
                }
            // Нажата кнопка с точкой
            case .dot:
                if !firstStrResult.contains(RoundButtonNumericValue.dot.rawValue) {
                    firstStrResult.append(numberItem.value.rawValue)
                }
            default:
                return
            }
            
        // Нажата кнопка с операцией "AC"
        case .operation:
            guard let operationItem = item as? RoundButtonOperationItem else { return }
            guard  operationItem.value == .clear else { return }
            clear()
            
        default:
            return
        }
    }
    
    /// Обработка удаления последнего символа
    func removeLast() {
        
        // Если число однозначеное, то сброс
        if firstStrResult.count == 1 {
            clear()
            return
        }
        
        firstStrResult = String(firstStrResult.dropLast())
    }
}

// MARK: Исполнение операции
extension ConverterImplementation {
    
    /// Сброс конвертера
    private func clear() {
        readyToInsertNewNumber = true
        firstStrResult = Config.NumberPresentation.strResultDefault
    }
    
    /// Вычисление второго числового результата
    private func calculateSecondNumericResult() -> Decimal {
        guard let firstCurrency = firstCurrency else { return 0.0 }
        guard let secondCurrency = secondCurrency else { return 0.0 }
        
        let firstValueInRubles: Decimal = (firstNumericResult * firstCurrency.value) / Decimal(firstCurrency.nominal)
        let secondValue: Decimal = (firstValueInRubles / secondCurrency.value) * Decimal(secondCurrency.nominal)
        
        return secondValue.rounded(Config.NumberPresentation.MaximumDigits.defaultFractionConv, .plain)
    }
}
