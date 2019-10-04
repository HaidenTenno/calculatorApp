//
//  ApiAnswers.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 03/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

struct ConverterApiAnswer: Codable {
    let date: String
    let previousDate: String
    let previousURL: String
    let timestamp: String
    let valute: [String:Currency]
    
    enum CodingKeys: String, CodingKey {
        case date = "Date"
        case previousDate = "PreviousDate"
        case previousURL = "PreviousURL"
        case timestamp = "Timestamp"
        case valute = "Valute"
    }
}

struct Currency: Codable {
    let id: String
    let numCode: String
    let charCode: String
    let nominal: Int
    let name: String
    let value: Decimal
    let previous: Decimal
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case numCode = "NumCode"
        case charCode = "CharCode"
        case nominal = "Nominal"
        case name = "Name"
        case value = "Value"
        case previous = "Previous"
    }
}
