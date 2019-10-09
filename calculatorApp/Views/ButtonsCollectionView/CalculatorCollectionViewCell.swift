//
//  CalculatorCollectionViewCell.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import AudioToolbox

class CalculatorCollectionViewCell: UICollectionViewCell {
    
    var item: CalculatorButtonItem!
    var tapButtonAction: ((CalculatorButtonItem)->())!
    
    var calculatorButton: UIButton! {
        didSet {
            addSubview(calculatorButton)
            configureButton()
        }
    }
    
    private func configureButton() {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? CalculatorButtonNumberItem else { return }
            calculatorButton.backgroundColor = Config.Design.Colors.numberButton
            calculatorButton.setTitle(numberItem.value.rawValue, for: .normal)
            
        case .operation:
            guard let operationItem = item as? CalculatorButtonOperationItem else { return }
            if operationItem.selected {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButton
            }
            calculatorButton.setTitle(operationItem.value.rawValue, for: .normal)
            
        case .mode:
            guard let  modeItem = item as? CalculatorButtonModeItem else { return }
            if modeItem.selected {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButton
            }
            calculatorButton.setTitle(modeItem.value.rawValue, for: .normal)
        }
        
        calculatorButton.layer.cornerRadius = CGFloat(Config.Design.CalculatorButtonSize.width/2)
        calculatorButton.titleLabel?.font = UIFont(name: Config.StringConsts.fontName, size: 30)
        calculatorButton.setTitleColor(Config.Design.Colors.buttonText, for: .normal)
        
        calculatorButton.snp.makeConstraints { make in
            make.height.equalTo(Config.Design.CalculatorButtonSize.hight)
            make.width.equalTo(Config.Design.CalculatorButtonSize.width)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        calculatorButton.addTarget(self, action: #selector(buttonTapped(sender:)), for: .touchUpInside)
    }
    
    @objc private func buttonTapped(sender: UIButton) {
        AudioServicesPlaySystemSound(0x450)
        tapButtonAction(item)
    }
}
