//
//  ConverterDQWrapper.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 21.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/// Обертка над Conerter для работы не в главном потоке
final class ConverterDQWrapper: Converter {
    
    private let queue: DispatchQueue
    
    private var converter: Converter
    
    init(converter: Converter = ConverterImplementation(),
         queue: DispatchQueue = DispatchQueue(label: Config.StringID.countingQueue, qos: .default, attributes: .concurrent)) {
        self.converter = converter
        self.queue = queue
    }
    
    // MARK: - Converter
    var firstCurrency: XMLCurrency? {
        get {
            return converter.firstCurrency
        }
        set {
            converter.firstCurrency = newValue
        }
    }
    
    var secondCurrency: XMLCurrency? {
        get {
            return converter.secondCurrency
        }
        set {
            converter.secondCurrency = newValue
        }
    }
    
    var firstStrResult: String {
        get {
            return converter.firstStrResult
        }
    }
    
    var secondStrResult: String {
        get {
            return converter.secondStrResult
        }
    }
    
    var firstNumericResult: Decimal {
        get {
            return converter.firstNumericResult
        }
    }
    
    var secondNumericResult: Decimal {
        get {
            return converter.secondNumericResult
        }
    }
    
    var delegate: ConverterDelegate? {
        get {
            return converter.delegate
        }
        set {
            converter.delegate = newValue
        }
    }
    
    func handleAction(of item: RoundButtonItem) {
        queue.sync { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.converter.handleAction(of: item)
        }
    }
    
    func removeLast() {        
        queue.sync { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.converter.removeLast()
        }
    }
}
