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
    
    init(type: SideMenuTableViewModelItemType) {
        self.type = type
    }
}

final class SideMenuTableViewModel {
    
    var items: [SideMenuTableViewModelItem] = []
    
    init() {
        
        for item in SideMenuTableViewModelItemType.allCases {
            let item = SideMenuTableViewModelItem(type: item)
            items.append(item)
        }
    }
    
}
