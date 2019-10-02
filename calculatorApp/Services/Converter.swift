//
//  Converter.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

protocol Converter {
    
    func handleAction(of item: CalculatorButtonNumberItem)
}

final class ConverterImplementation: Converter {
    
    static let shared = ConverterImplementation()
    
    private init() {}
    
    func handleAction(of item: CalculatorButtonNumberItem) {
        print("Not implemented")
    }
}
