//
//  NumberPresenterService.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 09.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

/// Варианты представления чисел для разных экранов
enum NumberPresenterServiceStyle {
    case calculator
    case converter
}

/// Сервис для форматирования чисел
final class NumberPresenterService {
    
    private let formatter: NumberFormatter
    private let style: NumberPresenterServiceStyle
    
    init(style: NumberPresenterServiceStyle) {
        let formatter = NumberFormatter()
        
        self.formatter = formatter
        self.style = style
    }
    
    /// Форматирование числа в соответствущем виде
    func format(string: String) -> String {
        if !checkIfNumber(string: string) { return string }
        
        // Для конвертера представление чисел обычное
        if style == .converter { return formatDecimal(string: string) }
        
        // Посчитать количество разрядов до и после разделителя
        let numberOfIntegerDigits = countIntegerDigits(of: string)
        let numberOfFractionDigits = countFractionDigits(of: string)
        
        // Число разрядов, которое определяет когда будет менятся представление числа
        let boundOfPresentationChange: Int
        
        // В зависимости от положения устройства "граница смены представления" меняется
        let orientation = UIDevice.current.orientation
        if orientation == .portrait {
            boundOfPresentationChange = 10
        } else {
            boundOfPresentationChange = 15
        }
        
        // Если граница превышена, то вернуть экспоненциальный вид числа
        if (numberOfIntegerDigits) > boundOfPresentationChange || (numberOfFractionDigits > boundOfPresentationChange) {
            return formatScientific(string: string)
        } else {
            return formatDecimal(string: string)
        }
        
    }
    
    /// Проверка, что строка является числом
    private func checkIfNumber(string: String) -> Bool {
        return Decimal(string: string) != nil
    }
    
    /// Форматирование числа в обычной записи
    private func formatDecimal(string: String) -> String {
        setupFormatterForDecimal()
        
        // Каст строки в NSNumber
        var result = string
        let decimalResult = Decimal(string: result)
        guard let nsNumberResult = decimalResult as NSNumber? else { return result }
        
        // Если последний символ в строке - разделитель, то добавить его в отформатированный вид
        if result.last == RoundButtonNumericValue.dot.rawValue.first {
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
            result.append(formatter.decimalSeparator)
        
        // Если в числе есть дробная часть
        } else if result.contains(RoundButtonNumericValue.dot.rawValue) {
            formatter.alwaysShowsDecimalSeparator = true
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
            
            // Если дробная часть оканичается незначащими нулями, до добавить их в отформатиованный вид
            if string.last == RoundButtonNumericValue.zero.rawValue.first {
                let arrayOfStrings = Array(string)
                for element in arrayOfStrings.reversed() {
                    if element == RoundButtonNumericValue.zero.rawValue.first {
                        result.append(RoundButtonNumericValue.zero.rawValue)
                    } else {
                        break
                    }
                }
            }
        // Если в числе нет дообной части
        } else {
            guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
            result = formattedResult
        }
        
        return result
    }
    
    /// Форматирование числа в экспоненциальной записи
    private func formatScientific(string: String) -> String {
        setupFormatterForScientific()
        
        var result = string

        let decimalResult = Decimal(string: result)
        guard let nsNumberResult = decimalResult as NSNumber? else { return result }
        guard let formattedResult = formatter.string(from: nsNumberResult) else { return result }
        result = formattedResult

        return result
    }
    
    /// Настойка formatter для представления чисел в обычной записи
    private func setupFormatterForDecimal() {
        formatter.numberStyle = .decimal
        formatter.alwaysShowsDecimalSeparator = false
        formatter.decimalSeparator = Locale.current.decimalSeparator
        formatter.usesGroupingSeparator = true
        formatter.groupingSeparator = Locale.current.groupingSeparator
        formatter.groupingSize = Config.NumberPresentation.groupingSize
        formatter.maximumSignificantDigits = -1
        
        switch style {
        case .calculator:
            formatter.maximumIntegerDigits = Config.NumberPresentation.MaximumDigits.showingInteger
            formatter.maximumFractionDigits = Config.NumberPresentation.MaximumDigits.showingFraction
        case .converter:
            formatter.maximumIntegerDigits = Config.NumberPresentation.MaximumDigits.defaultIntegerConv
            formatter.maximumFractionDigits = Config.NumberPresentation.MaximumDigits.defaultFractionConv
        }
    }
    
    /// Настройка formatter для представления чисел в экспоненциальной записи
    private func setupFormatterForScientific() {
        formatter.numberStyle = .scientific
        formatter.alwaysShowsDecimalSeparator = false
        formatter.exponentSymbol = Config.NumberPresentation.exponentialSymbol
        formatter.maximumSignificantDigits = 6
        formatter.maximumFractionDigits = 0
    }
    
    /// Подсчет разрядов до разделителя
    private func countIntegerDigits(of string: String) -> Int {
        if !string.contains(RoundButtonNumericValue.dot.rawValue) { return string.count }
        
        let indexOfSeparator = string.firstIndex(of: RoundButtonNumericValue.dot.rawValue.first!)!
        let decimalPart = string.prefix(upTo: indexOfSeparator)
        return decimalPart.count
    }
    
    /// Подсчет разрядов после разделителя
    private func countFractionDigits(of string: String) -> Int {
        if !string.contains(RoundButtonNumericValue.dot.rawValue) { return 0 }
        
        let reversedString = String(string.reversed())
        
        let indexOfSeparator = reversedString.firstIndex(of: RoundButtonNumericValue.dot.rawValue.first!)!
        let decimalPart = string.prefix(upTo: indexOfSeparator)
        return decimalPart.count
    }
}
