//
//  CalculatorButton.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 30/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol CalculatorButtonItem {
    var type: CalculatorButtonType { get }
}

class CalculatorButtonNumberItem: CalculatorButtonItem {
    
    var type: CalculatorButtonType = .number
    var value: CalculatorButtonNumericValue
    
    init(value: CalculatorButtonNumericValue) {
        self.value = value
    }
}

class CalculatorButtonOperationItem: CalculatorButtonItem {
    
    var type: CalculatorButtonType = .operation
    var value: CalculatorButtonOperationValue
    var selected: Bool = false
    
    init(value: CalculatorButtonOperationValue) {
        self.value = value
    }
}

class CalculatorButtonModeItem: CalculatorButtonItem {
    
    var type: CalculatorButtonType = .mode
    var value: CalculatorButtonModeValue
    var selected: Bool = false
    
    init(value: CalculatorButtonModeValue) {
        self.value = value
    }
}

enum CalculatorButtonType: CaseIterable {
    case number
    case operation
    case mode
}

enum CalculatorButtonNumericValue: String, CaseIterable {
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
}

enum CalculatorButtonOperationValue: String, CaseIterable {
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
}

enum CalculatorButtonModeValue: String, CaseIterable {
    case deg = "Deg"
    case rad = "Rad"
}

final class CalculatorModel {
    
    var items: [CalculatorButtonItem] = []
    
    init() {
        
        for numberItem in CalculatorButtonNumericValue.allCases {
            let item = CalculatorButtonNumberItem(value: numberItem)
            items.append(item)
        }
        
        for operatorItem in CalculatorButtonOperationValue.allCases {
            let item = CalculatorButtonOperationItem(value: operatorItem)
            items.append(item)
        }
        
        for modeItem in CalculatorButtonModeValue.allCases {
            let item = CalculatorButtonModeItem(value: modeItem)
            if item.value == .deg {
                item.selected = true
            }
            items.append(item)
        }
    }
    
    private func deselectAllOperations() {
        for item in items {
            guard let operationItem = item as? CalculatorButtonOperationItem else { continue }
            operationItem.selected = false
        }
    }
    
    private func deselectAllModes() {
        for item in items {
            guard let modeItem = item as? CalculatorButtonModeItem else { continue }
            modeItem.selected = false
        }
    }
}

extension CalculatorModel: CalculatorDelegate {
    
    func calculatorSelectedNewOperation(_ calculator: Calculator) {
        deselectAllOperations()
    }
    
    func calculatorSelectedNewMode(_ calculator: Calculator) {
        deselectAllModes()
    }
}
