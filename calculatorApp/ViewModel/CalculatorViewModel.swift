//
//  CalculatorViewModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 30/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/**
 Делегат CalculatorViewModel
 
 `calculatorViewModelDidUpdateValue` - Изменение значения для отображения
 `calculatorViewModelDidUpdateMode` - Изменение режима
 */
protocol CalculatorViewModelDelegate: class {
    func calculatorViewModelDidUpdateValue(_ viewModel: CalculatorViewModel)
    func calculatorViewModelDidUpdateMode(_ viewModel: CalculatorViewModel)
}

/// Модель отображения калькулятра
final class CalculatorViewModel {
    
    weak var delegate: CalculatorViewModelDelegate?
    
    var strValue: String = Config.NumberPresentation.strResultDefault {
        didSet {
            delegate?.calculatorViewModelDidUpdateValue(self)
        }
    }
    
    var mode: RoundButtonModeValue = Config.Calculator.defaultMode {
        didSet {
            delegate?.calculatorViewModelDidUpdateMode(self)
        }
    }
    
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

// MARK: - CalculatorDelegate
extension CalculatorViewModel: CalculatorDelegate {
    
    func calculator(_ calculator: Calculator, didUpdate strValue: String) {
        self.strValue = strValue
    }
    
    func calculator(_ calculator: Calculator, didSelect newMode: RoundButtonModeValue) {
        deselectAllModes()
        self.mode = newMode
    }
    
    func calculator(_ calculator: Calculator, didSelect operation: RoundButtonOperationItem?) {
        deselectAllOperations()
        operation?.selected = true
    }
}
