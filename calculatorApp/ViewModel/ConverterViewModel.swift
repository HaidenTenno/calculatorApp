//
//  ConverterViewModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/**
 Делегат ConverterViewModel
 
 `converterViewModelDidUpdateValue` - Изменение значений для отображения
 */
protocol ConverterViewModelDelegate: class {
    func converterViewModelDidUpdateValue(_ viewModel: ConverterViewModel)
}

/// Модель отображения конвертера
final class ConverterViewModel {
    
    weak var delegate: ConverterViewModelDelegate?
    
    var items: [RoundButtonItem] = []
    
    /**
     Массив валют
     
     - important
     Если устанавливается новый массив валют, то в него добавляются рубли (т.к. в ответе API их нет) и выбраются соответствующая Locale первая валюта
     */
    var valute: [XMLCurrency] = [] {
        didSet {
            let ruble = XMLCurrency(numCode: "None",
                                    charCode: "RUB",
                                    nominal: 1,
                                    name: NSLocalizedString("Russian ruble", comment: "RUB currency name"),
                                    value: 1.0)
            self.valute.insert(ruble, at: 0)
            
            let currentRegionCode = Locale.current.currencyCode ?? Config.Localization.defaultFirstCurrency
            
            let firstSelectedIndex = self.valute.firstIndex(where: { $0.charCode ==
                currentRegionCode
            }) ?? 0
            let secondSelectedIndex = self.valute.firstIndex(where: { $0.charCode ==
                Config.Localization.defaultSecondCurrency
            }) ?? 0
            
            firstSelectedCurrency = self.valute[firstSelectedIndex]
            secondSelectedCurrency = self.valute[secondSelectedIndex]
        }
    }
    
    // Первая и вторая выбранные валюты
    var firstSelectedCurrency: XMLCurrency?
    var secondSelectedCurrency: XMLCurrency?
    
    // Текстовые значения результатов
    var firstStrResult: String = Config.NumberPresentation.strResultDefault {
        didSet {
            delegate?.converterViewModelDidUpdateValue(self)
        }
    }
    var secondStrResult: String = Config.NumberPresentation.strResultDefault {
        didSet {
            delegate?.converterViewModelDidUpdateValue(self)
        }
    }
    
    // На экране конвертера используются только кнопки цифр, разделителя и сброса
    init() {
        for numberItem in RoundButtonNumericValue.allCases {
            let item = RoundButtonNumberItem(value: numberItem)
            switch item.value {
            case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .dot:
                items.append(item)
            default:
                continue
            }
        }
        
        let clearItem = RoundButtonOperationItem(value: .clear)
        items.append(clearItem)
    }
        
    // Поменять выбранные валюты местами
    private func swapCurrency() {
        let rememberedCurrency = firstSelectedCurrency
        firstSelectedCurrency = secondSelectedCurrency
        secondSelectedCurrency = rememberedCurrency
    }
}

// MARK: - ConverterDelegate
extension ConverterViewModel: ConverterDelegate {
    
    func converter(_ converter: Converter, didUpdate firsStrResult: String, _ secondStrResult: String) {
        self.firstStrResult = firsStrResult
        self.secondStrResult = secondStrResult
    }
    
    func converter(_ converter: Converter, didSelect firstCurrency: XMLCurrency?, secondCurrency: XMLCurrency?) {
        if let firstCurrency = firstCurrency {
            firstSelectedCurrency = firstCurrency
        }
        
        if let secondCurrency = secondCurrency {
            secondSelectedCurrency = secondCurrency
        }
    }
}
