//
//  CalculatorViewModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 30/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/// Модель отображения калькулятра
final class CalculatorViewModel {
    
    var items: [RoundButtonItem] = []
    
    // На экране калькулятора используются все возможные кругрые кнопки
    init() {
        for numberItem in RoundButtonNumericValue.allCases {
            let item = RoundButtonNumberItem(value: numberItem)
            items.append(item)
        }
        
        for operationItem in RoundButtonOperationValue.allCases {
            let item = RoundButtonOperationItem(value: operationItem)
            items.append(item)
        }
        
        for modeItem in RoundButtonModeValue.allCases {
            let item = RoundButtonModeItem(value: modeItem)
            if item.value == .deg {
                item.selected = true
            }
            items.append(item)
        }
    }
    
    private func deselectAllOperations() {
        for item in items {
            guard let operationItem = item as? RoundButtonOperationItem else { continue }
            operationItem.selected = false
        }
    }
    
    private func deselectAllModes() {
        for item in items {
            guard let modeItem = item as? RoundButtonModeItem else { continue }
            modeItem.selected = false
        }
    }
}

// Если выбирается новая операция (режим), то убать выбор с предыдущих операций (режимов)
extension CalculatorViewModel: CalculatorDelegate {
    
    func calculatorSelectedNewOperation(_ calculator: Calculator) {
        deselectAllOperations()
    }
    
    func calculatorSelectedNewMode(_ calculator: Calculator) {
        deselectAllModes()
    }
}
