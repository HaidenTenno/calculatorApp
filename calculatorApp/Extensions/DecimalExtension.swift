//
//  DecimalExtension.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 01/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

extension Decimal {
    mutating func round(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) {
        var localCopy = self
        NSDecimalRound(&self, &localCopy, scale, roundingMode)
    }

    func rounded(_ scale: Int, _ roundingMode: NSDecimalNumber.RoundingMode) -> Decimal {
        var result = Decimal()
        var localCopy = self
        NSDecimalRound(&result, &localCopy, scale, roundingMode)
        return result
    }
}
