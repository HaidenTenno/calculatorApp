//
//  CalculatorButton.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

private enum CalculatorButtonType {
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
    case comma = ","
    
    case plus = "+"
    case minus = "-"
    case multiplication = "*"
    case division = "÷"
    case exp = "^"
    case sin = "sin"
    case cos = "cos"
    case tan = "tan"
    case log = "log"
}

class CalculatorButton: UIButton {
    
    private var calculatorType: CalculatorButtonType
    private var calculatorValue: CalculatorButtonValue
    
    init(calculatorValue: CalculatorButtonValue) {

        self.calculatorValue = calculatorValue

        switch calculatorValue {
        case .one, .two, .three, .four, .five, .six, .seven, .eight, .nine, .zero, .comma:
            calculatorType = .number

        case .plus, .minus, .multiplication, .division, .exp, .sin, .cos, .tan, .log:
            calculatorType = .operation

        }

        super.init(frame: .zero)
        
        switch calculatorType {
        case .number:
            backgroundColor = .yellow
        case .operation:
            backgroundColor = .green
        }

        self.layer.cornerRadius = CGFloat(Config.CalculatorButtonSize.width/2)
        self.backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        self.setTitle(calculatorValue.rawValue, for: .normal)
        self.titleLabel?.font = .systemFont(ofSize: 30)
        self.setTitleColor(.label, for: .normal)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(Config.CalculatorButtonSize.hight)
            make.width.equalTo(Config.CalculatorButtonSize.width)
        }
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            }
            else {
                backgroundColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
            }
            super.isHighlighted = newValue
        }
    }
}
