//
//  NoMenuTextField.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 05/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class NoMenuTextField: UITextField {
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        .zero
    }
    
    override func selectionRects(for range: UITextRange) -> [UITextSelectionRect] {
        []
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }    
}
