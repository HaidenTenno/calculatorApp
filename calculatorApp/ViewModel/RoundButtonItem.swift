//
//  RoundButtonItem.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 16.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/// Типы круглых кнопок
enum RoundButtonType: CaseIterable {
    case number
    case operation
    case mode
}

/// Протокол круглой кнопки
protocol RoundButtonItem {
    var type: RoundButtonType { get }
}

// MARK: Классы для круглых кнопок различных типов
/// Круглая кнопка числа
class RoundButtonNumberItem: RoundButtonItem {
    var type: RoundButtonType = .number
    var value: RoundButtonNumericValue
    
    init(value: RoundButtonNumericValue) {
        self.value = value
    }
}

/// Круглая кнопка операции
class RoundButtonOperationItem: RoundButtonItem {
    var type: RoundButtonType = .operation
    var value: RoundButtonOperationValue
    var selected: Bool = false
    
    init(value: RoundButtonOperationValue) {
        self.value = value
    }
}

/// Круглая кнопка режима
class RoundButtonModeItem: RoundButtonItem {
    var type: RoundButtonType = .mode
    var value: RoundButtonModeValue
    var selected: Bool = false
    
    init(value: RoundButtonModeValue) {
        self.value = value
    }
}

// MARK: Перечисления возможных значений круглых кнопок различных типов
/// Значения кнопок чисел
enum RoundButtonNumericValue: String, CaseIterable {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case dot = "."
    case pi = "𝛑"
    
    /**
     - important
     Свойство `stringValue` необходимо для корректного отображения разделителя дробной части в разных Locale
     */
    var stringValue: String {
        switch self {
        case .dot:
            return Locale.current.decimalSeparator ?? self.rawValue
        default:
            return self.rawValue
        }
    }
}

/// Значения кнопок числа
enum RoundButtonOperationValue: String, CaseIterable {
    case clear = "AC"
    case changeSign = "±"
    case plus = "+"
    case minus = "-"
    case multiplication = "×"
    case division = "÷"
    case power = "^"
    case sqrt = "√"
    case log = "log"
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case execute = "="
    
    var stringValue: String {
        return self.rawValue
    }
}

/// Значения кнопок режима
enum RoundButtonModeValue: String, CaseIterable {
    case deg = "Deg"
    case rad = "Rad"
    
    var stringValue: String {
        return self.rawValue
    }
}
