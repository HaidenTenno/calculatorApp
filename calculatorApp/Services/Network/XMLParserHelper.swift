//
//  XMLParserHelper.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 09.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation
import AEXML

enum XMLParserHelperError: Error {
    case moduleError(_ error: Error)
    case parsingError
}

final class XMLParserHelper {
    
    static let shared = XMLParserHelper()
    
    private var numberFormatter: NumberFormatter {
        let numberFormatter = NumberFormatter()
        numberFormatter.decimalSeparator = ","
        return numberFormatter
    }
    
    private init() {}
    
    func parseXMLIntoCurrency(xml: Data) throws -> [XMLCurrency] {
        
        do {
            let xml = try AEXMLDocument(xml: xml)
            
            var parsedXML: [XMLCurrency] = []
            
            for element in xml.root.children {
                
                guard
                    let numCode = element["NumCode"].value,
                    let charCode = element["CharCode"].value,
                    let nominal = element["Nominal"].value,
                    let intNominal = Int(nominal),
                    let name = element["Name"].value,
                    let value = element["Value"].value,
                    let decimalValue = numberFormatter.number(from: value)?.decimalValue.rounded(Config.NumberPresentation.MaximumDigits.defaultFractionConv, .plain)
                    
                    else {
                        throw XMLParserHelperError.parsingError
                }
                
                let currency = XMLCurrency(numCode: numCode,
                                           charCode: charCode,
                                           nominal: intNominal,
                                           name: name,
                                           value: decimalValue)
                parsedXML.append(currency)
            }
            return parsedXML
            
        } catch {
            throw XMLParserHelperError.moduleError(error)
        }
    }
}
