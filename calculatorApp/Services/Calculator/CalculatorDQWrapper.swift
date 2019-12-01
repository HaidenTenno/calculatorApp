//
//  CalculatorDQWrapper.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 21.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/// Обертка над Calculator для работы не в главном потоке
final class CalculatorDQWrapper: Calculator {
    
    private let queue: DispatchQueue
    
    private var calculator: Calculator
    
    init(calculator: Calculator = CalculatorImplementation(),
         queue: DispatchQueue = DispatchQueue(label: Config.StringID.countingQueue, qos: .userInitiated, attributes: .concurrent)) {
        self.calculator = calculator
        self.queue = queue
    }
    
    // MARK: Calculator
    var strValue: String {
        get {
            return calculator.strValue
        }
    }
    
    var currentValue: Decimal {
        get {
            return calculator.currentValue
        }
    }
    
    var mode: RoundButtonModeValue {
        get {
            return calculator.mode
        }
    }
    
    var delegate: CalculatorDelegate? {
        get {
            return calculator.delegate
        }
        set {
            calculator.delegate = newValue
        }
    }
    
    func handleAction(of item: RoundButtonItem, completion: (() -> Void)?) {
        queue.async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.calculator.handleAction(of: item) {
                DispatchQueue.main.async {
                    completion?()
                }
            }
        }
    }
    
    func removeLast() {
        calculator.removeLast()
    }
    
    
}
