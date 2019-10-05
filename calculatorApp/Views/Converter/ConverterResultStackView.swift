//
//  ConverterResultStackView.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

protocol ConverterResultStackViewDelegate: class {
    func converterResultStackViewSwipedLeft(_ converterResultStackView: ConverterResultStackView)
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewFirstCurrency: Currency)
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewSecondCurrency: Currency)
}

class ConverterResultStackView: UIStackView {
    
    private var resultLabel: UILabel!
    private var pickerView: UIPickerView!
    private var selectedCurrencyTextField: NoMenuTextField!
    
    private var editable: Bool!
    
    weak var converterVC: ConverterScreenViewController?
    weak var delegate: ConverterResultStackViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(editable: Bool) {
        
        self.editable = editable
        
        //self
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        
        //selectedCurrencyTextField
        selectedCurrencyTextField = NoMenuTextField()
        selectedCurrencyTextField.font = UIFont(name: Config.fontName, size: 20)
        selectedCurrencyTextField.textColor = Config.Colors.label
        selectedCurrencyTextField.borderStyle = .none
        selectedCurrencyTextField.tintColor = .clear
        self.addArrangedSubview(selectedCurrencyTextField)

        //resultLabel
        resultLabel = UILabel()
        resultLabel.font = UIFont(name: Config.fontName, size: 50)
        resultLabel.textColor = Config.Colors.label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0
        resultLabel.numberOfLines = 0
        resultLabel.isUserInteractionEnabled = editable
        //Remove last gesture
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(resultSwipedToLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        resultLabel.addGestureRecognizer(swipeLeftGesture)
        self.addArrangedSubview(resultLabel)
        
        //pickerView
        setupOptionPicker()
        
        //fillDataFromModel
        reloadData()
    }
    
    func makeConstraints() {
        
        selectedCurrencyTextField.snp.makeConstraints { make in
            make.width.equalTo(60)
        }
    }
    
    @objc private func resultSwipedToLeft() {
        delegate?.converterResultStackViewSwipedLeft(self)
    }
    
    private func setupOptionPicker() {
        pickerView = UIPickerView()
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Готово", style: .done, target: self, action: #selector(donePressed))

        let items = [cancelButton, spaceButton, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        selectedCurrencyTextField.inputView = pickerView
        selectedCurrencyTextField.inputAccessoryView = toolbar
    }
    
    @objc private func donePressed() {
        
        guard let model = converterVC?.model else {
            cancelPressed()
            return
        }
        
        let selectedCurrency = Array(model.valute)[pickerView.selectedRow(inComponent: 0)].value
        
        if editable {
            model.firstSelectedCurrency = selectedCurrency
            delegate?.converterResultStackView(self, didSelectNewFirstCurrency: selectedCurrency)
        } else {
            model.secondSelectedCurrency = selectedCurrency
            delegate?.converterResultStackView(self, didSelectNewSecondCurrency: selectedCurrency)
        }
        
        selectedCurrencyTextField.resignFirstResponder()
    }
    
    @objc private func cancelPressed() {
        selectedCurrencyTextField.resignFirstResponder()
    }
    
    func reloadData() {
        
        //selectedCurrencyTextField
        let valueForTextField: String?
        if editable {
            valueForTextField = converterVC?.model.firstSelectedCurrency?.charCode ?? "ER1"
        } else {
            valueForTextField = converterVC?.model.secondSelectedCurrency?.charCode ?? "ER2"
        }
        
        selectedCurrencyTextField.text = valueForTextField
                
        //resultLabel
        if editable {
            resultLabel.text = converterVC?.converterService.firstStrResult ?? "none"
        } else {
            resultLabel.text = converterVC?.converterService.secondStrResult ?? "none"
        }
        
        //pickerView
        guard let converterVC = converterVC else { return }
        
        var rowToSelect: Int
        if editable {
            guard let selectedStrCode = converterVC.model.firstSelectedCurrency?.charCode else { return }
            rowToSelect = Array(converterVC.model.valute.keys).firstIndex(of: selectedStrCode) ?? 0
        } else {
            guard let selectedStrCode = converterVC.model.secondSelectedCurrency?.charCode else { return }
            rowToSelect = Array(converterVC.model.valute.keys).firstIndex(of: selectedStrCode) ?? 0
        }
                
        pickerView.selectRow(rowToSelect, inComponent: 0, animated: false)
    }
}

extension ConverterResultStackView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let model = converterVC?.model.valute else { return 0 }
        return model.count
    }
        
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let model = converterVC?.model.valute else { return nil }
        let element = Array(model)[row].value
        return element.charCode + " - " + element.name
    }
}
