//
//  CalculatorCollectionViewCell.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class CalculatorCollectionViewCell: UICollectionViewCell {
    
    var calculatorButton: CalculatorButton! {
        didSet {
            addSubview(calculatorButton)
            calculatorButton.snp.makeConstraints { make in
                make.left.equalTo(contentView)
                make.right.equalTo(contentView)
                make.top.equalTo(contentView)
                make.bottom.equalTo(contentView)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
