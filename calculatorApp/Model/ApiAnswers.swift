//
//  ApiAnswers.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 03/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/// Модель для получения списка валют из сети
struct XMLCurrency {
    let numCode: String
    let charCode: String
    let nominal: Int
    let name: String
    let value: Decimal
}
