//
//  ButtonsCollectionViewCell.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import AudioToolbox

class ButtonsCollectionViewCell: UICollectionViewCell {
    
    var item: RoundButtonItem!
    var tapButtonAction: ((RoundButtonItem)->())!
    
    var calculatorButton: UIButton! {
        didSet {
            addSubview(calculatorButton)
            configureButton()
        }
    }
    
    private func configureButton() {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? RoundButtonNumberItem else { return }
            calculatorButton.backgroundColor = Config.Design.Colors.numberButton
            calculatorButton.setTitle(numberItem.value.stringValue, for: .normal)
            
        case .operation:
            guard let operationItem = item as? RoundButtonOperationItem else { return }
            if operationItem.selected {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButton
            }
            calculatorButton.setTitle(operationItem.value.stringValue, for: .normal)
            
        case .mode:
            guard let  modeItem = item as? RoundButtonModeItem else { return }
            if modeItem.selected {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                calculatorButton.backgroundColor = Config.Design.Colors.functionButton
            }
            calculatorButton.setTitle(modeItem.value.stringValue, for: .normal)
        }
        
        calculatorButton.layer.cornerRadius = CGFloat(Config.Design.RoundButtonSize.width/2)
        calculatorButton.titleLabel?.font = UIFont(name: Config.Design.fontName, size: 30)
        calculatorButton.setTitleColor(Config.Design.Colors.buttonText, for: .normal)
        
        calculatorButton.snp.makeConstraints { make in
            make.height.equalTo(Config.Design.RoundButtonSize.hight)
            make.width.equalTo(Config.Design.RoundButtonSize.width)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        calculatorButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        AudioServicesPlaySystemSound(0x450)
        tapButtonAction(item)
    }
}
