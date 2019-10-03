//
//  SideMenuTableViewModel.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 03/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import Foundation

enum SideMenuTableViewModelItemType: String, CaseIterable {
    case calculator = "Калькулятор"
    case converter = "Конвертер"
}

class SideMenuTableViewModelItem {
    
    var type: SideMenuTableViewModelItemType
    var active: Bool = true
    
    init(type: SideMenuTableViewModelItemType) {
        self.type = type
    }
}

final class SideMenuTableViewModel {
    
    var items: [SideMenuTableViewModelItem] = []
    
    init(activeType: SideMenuTableViewModelItemType) {
        
        for item in SideMenuTableViewModelItemType.allCases {
            let item = SideMenuTableViewModelItem(type: item)
            item.active = item.type == activeType ? false : true
            items.append(item)
        }        
    }
}
