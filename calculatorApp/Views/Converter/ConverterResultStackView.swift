//
//  ConverterResultStackView.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class ConverterResultStackView: UIStackView {

    private var selectedCurrencyTextField: UITextField!
    private var resultLabel: UILabel!
    private var pickerView: UIPickerView!
    
    override init(frame: CGRect) {
        
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(editable: Bool) {
        
        //self
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        
        //selectedCurrencyTextView
        selectedCurrencyTextField = UITextField()
        selectedCurrencyTextField.font = UIFont(name: Config.fontName, size: 20)
        selectedCurrencyTextField.textColor = Config.Colors.label
        selectedCurrencyTextField.borderStyle = .none
        selectedCurrencyTextField.text = "DEF"
        addArrangedSubview(selectedCurrencyTextField)
        
        //resultLabel
        resultLabel = UILabel()
        resultLabel.text = "0"
        resultLabel.font = UIFont(name: Config.fontName, size: 50)
        resultLabel.textColor = Config.Colors.label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0
        resultLabel.numberOfLines = 1
        resultLabel.isUserInteractionEnabled = editable
        addArrangedSubview(resultLabel)
        
        //pickerView
        
//        selectedCurrencyTextField.inputView = selectedCurrencyTextField
        
        makeConstraints()
    }

    private func makeConstraints() {
        
        selectedCurrencyTextField.snp.makeConstraints { make in
            make.width.equalTo(100)
        }
    }
    
}
