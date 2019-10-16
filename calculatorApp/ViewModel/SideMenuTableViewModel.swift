//
//  SideMenuTableViewModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 03/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

/**
 Типы элементов бокового меню
 
 - important
 Отсюда следует начинать добавлять новые экраны, выбираемые через боковое меню
 */
enum SideMenuTableViewModelItemType: String, CaseIterable {
    case calculator = "Calculator"
    case converter = "Converter"
    
    func localizedString() -> String {
        return NSLocalizedString(self.rawValue, comment: "")
    }

    static func getTitleFor(title: SideMenuTableViewModelItemType) -> String {
        return title.localizedString()
    }
}

/// Элемент бокового меню
class SideMenuTableViewModelItem {
    
    var type: SideMenuTableViewModelItemType
    var active: Bool = true
    
    init(type: SideMenuTableViewModelItemType) {
        self.type = type
    }
}

/// Модель отображения бокового меню
final class SideMenuTableViewModel {
    
    var items: [SideMenuTableViewModelItem] = []
    
    init(activeType: SideMenuTableViewModelItemType) {
        
        for item in SideMenuTableViewModelItemType.allCases {
            let item = SideMenuTableViewModelItem(type: item)
            // Сделать невозможным выбор контроллера такого же типа
            item.active = item.type == activeType ? false : true
            items.append(item)
        }        
    }
}
