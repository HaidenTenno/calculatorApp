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
    
    private var item: RoundButtonItem!
    private var tapButtonAction: ((RoundButtonItem)->())!
    
    private var roundButton: UIButton! {
        didSet {
            addSubview(roundButton)
            configureButton()
        }
    }
    
    func configure(item: RoundButtonItem, roundButton: UIButton, action: @escaping (RoundButtonItem)->()) {
        self.item = item
        self.roundButton = roundButton
        self.tapButtonAction = action
    }
    
    private func configureButton() {
        
        switch item.type {
        case .number:
            guard let numberItem = item as? RoundButtonNumberItem else { return }
            roundButton.backgroundColor = Config.Design.Colors.numberButton
            roundButton.setTitle(numberItem.value.stringValue, for: .normal)
            
        case .operation:
            guard let operationItem = item as? RoundButtonOperationItem else { return }
            if operationItem.selected {
                roundButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                roundButton.backgroundColor = Config.Design.Colors.functionButton
            }
            roundButton.setTitle(operationItem.value.stringValue, for: .normal)
            
        case .mode:
            guard let  modeItem = item as? RoundButtonModeItem else { return }
            if modeItem.selected {
                roundButton.backgroundColor = Config.Design.Colors.functionButtonSelected
            } else {
                roundButton.backgroundColor = Config.Design.Colors.functionButton
            }
            roundButton.setTitle(modeItem.value.stringValue, for: .normal)
        }
        
        roundButton.layer.cornerRadius = CGFloat(Config.Design.RoundButtonSize.width/2)
        roundButton.titleLabel?.font = UIFont(name: Config.Design.fontName, size: 30)
        roundButton.setTitleColor(Config.Design.Colors.buttonText, for: .normal)
        
        roundButton.snp.makeConstraints { make in
            make.height.equalTo(Config.Design.RoundButtonSize.hight)
            make.width.equalTo(Config.Design.RoundButtonSize.width)
            make.left.equalTo(contentView)
            make.right.equalTo(contentView)
            make.top.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        roundButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    @objc private func buttonTapped() {
        AudioServicesPlaySystemSound(0x450)
        tapButtonAction(item)
    }
}
