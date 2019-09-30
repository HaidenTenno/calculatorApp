//
//  CalculatorCollectionViewCell.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

enum CalculatorButtonType: CaseIterable {
    case number
    case operation
}

enum CalculatorButtonValue: String, CaseIterable {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case dot = "."
    
    case clear = "AC"
    case plus = "+"
    case minus = "-"
    case multiplication = "*"
    case division = "÷"
    case exp = "^"
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case log = "log"
    case execute = "="
}

class CalculatorCollectionViewCell: UICollectionViewCell {
    
    var calculatorButtonType: CalculatorButtonType!
    var calculatorButtonValue: CalculatorButtonValue!
    
    var tabButtonAction: ((CalculatorCollectionViewCell)->())!
    
    var calculatorButton: UIButton! {
        didSet {
            addSubview(calculatorButton)
            
            configureButton()
        }
    }
    
    private func configureButton() {
        
        guard let calculatorButtonValue = calculatorButtonValue else { return }
        
        switch calculatorButtonValue {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .dot:
            calculatorButtonType = .number

        case .clear, .plus, .minus, .multiplication, .division, .exp, .sin, .cos, .tan, .log, .execute:
            calculatorButtonType = .operation

        }
                
        switch calculatorButtonType {
        case .number:
            calculatorButton.backgroundColor = .systemOrange
        case .operation:
            calculatorButton.backgroundColor = .systemYellow
        case .none:
            fatalError()
        }

        calculatorButton.layer.cornerRadius = CGFloat(Config.CalculatorButtonSize.width/2)
        calculatorButton.setTitle(calculatorButtonValue.rawValue, for: .normal)
        calculatorButton.titleLabel?.font = .systemFont(ofSize: 30)
        calculatorButton.setTitleColor(.label, for: .normal)
        
        calculatorButton.snp.makeConstraints { make in
            make.height.equalTo(Config.CalculatorButtonSize.hight)
            make.width.equalTo(Config.CalculatorButtonSize.width)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        calculatorButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        tabButtonAction(self)
    }
}
