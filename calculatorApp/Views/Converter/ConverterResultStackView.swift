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
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewFirstCurrency: XMLCurrency)
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewSecondCurrency: XMLCurrency)
}

class ConverterResultStackView: UIStackView {
    
    // UI элементы
    private var resultLabel: UILabel!
    private var pickerView: UIPickerView!
    private var selectedCurrencyTextField: NoMenuTextField!
    
    // Модель
    private let model: ConverterViewModel
    
    // Сервисы
    private var presenterService = NumberPresenterService(style: .converter)
    
    // Текст для отображения
    private var textToShow: String? {
        didSet {
            guard let textToShow = textToShow else { return }
            resultLabel.text = presenterService.format(string: textToShow)
        }
    }
    
    // Делегат
    private weak var delegate: ConverterResultStackViewDelegate?
    
    // Возможность взаимодействия
    private let editable: Bool
    
    init(model: ConverterViewModel, editable: Bool, delegate: ConverterResultStackViewDelegate) {
        self.model = model
        self.delegate = delegate
        self.editable = editable
        super.init(frame: .zero)
        configure(editable: editable)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI
    func makeConstraints() {
        selectedCurrencyTextField.snp.makeConstraints { make in
            make.width.equalTo(50)
        }
    }
    
    private func configure(editable: Bool) {
        
        //self
        self.axis = .horizontal
        self.distribution = .fill
        self.alignment = .center
        
        //selectedCurrencyTextField
        selectedCurrencyTextField = NoMenuTextField()
        selectedCurrencyTextField.font = UIFont(name: Config.Design.fontName, size: 20)
        selectedCurrencyTextField.textColor = Config.Design.Colors.label
        selectedCurrencyTextField.borderStyle = .none
        selectedCurrencyTextField.tintColor = .clear
        selectedCurrencyTextField.delegate = self
        self.addArrangedSubview(selectedCurrencyTextField)
        
        //resultLabel
        resultLabel = UILabel()
        resultLabel.font = UIFont(name: Config.Design.fontName, size: 50)
        resultLabel.textColor = Config.Design.Colors.label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0
        resultLabel.numberOfLines = 1
        resultLabel.isUserInteractionEnabled = editable
        //Remove last gesture
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(resultSwipedToLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        resultLabel.addGestureRecognizer(swipeLeftGesture)
        self.addArrangedSubview(resultLabel)
        
        //pickerView
        setupOptionPicker()
        
        // Заполнить значения
        reloadData()
    }
    
    private func setupOptionPicker() {
        pickerView = UIPickerView()
        
        pickerView?.delegate = self
        pickerView?.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        toolbar.barStyle = .default
        let cancelButton = UIBarButtonItem(title: Config.Localization.cancel, style: .plain, target: self, action: #selector(cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Config.Localization.done, style: .done, target: self, action: #selector(donePressed))
        
        let items = [cancelButton, spaceButton, doneButton]
        toolbar.items = items
        toolbar.sizeToFit()
        
        selectedCurrencyTextField.inputView = pickerView
        selectedCurrencyTextField.inputAccessoryView = toolbar
    }
}

// MARK: - Данные
extension ConverterResultStackView {
    
    func reloadData() {
        
        //selectedCurrencyTextField
        let valueForTextField: String?
        if editable {
            valueForTextField = model.firstSelectedCurrency?.charCode ?? ""
        } else {
            valueForTextField =  model.secondSelectedCurrency?.charCode ?? ""
        }
        
        selectedCurrencyTextField.text = valueForTextField
        
        //resultLabel
        if editable {
            textToShow = model.firstStrResult
        } else {
            textToShow = model.secondStrResult
        }
        
        //pickerView
        selectProperRow()
    }
    
    private func selectProperRow() {
        
        let selectedCurrency: XMLCurrency
        
        if editable {
            guard model.firstSelectedCurrency != nil else { return }
            selectedCurrency = model.firstSelectedCurrency!
        } else {
            guard model.secondSelectedCurrency != nil else { return }
            selectedCurrency = model.secondSelectedCurrency!
        }
        guard let rowToSelect = model.valute.firstIndex(where: { $0.charCode == selectedCurrency.charCode }) else { return }
        pickerView.selectRow(rowToSelect, inComponent: 0, animated: false)
    }
}

// MARK: - Обработчики жестов и нажатий
extension ConverterResultStackView {
    
    @objc private func resultSwipedToLeft() {
        delegate?.converterResultStackViewSwipedLeft(self)
    }
    
    @objc private func donePressed() {
        
        let selectedRow = pickerView.selectedRow(inComponent: 0)
        
        guard model.valute.count > selectedRow else {
            cancelPressed()
            return
        }
        
        let selectedCurrency = model.valute[selectedRow]
        
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
}

// MARK: - PickerView
extension ConverterResultStackView: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return model.valute.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let element = model.valute[row]
        return element.charCode + " - " + element.name
    }
}

// MARK: - UITextFieldDelegate
extension ConverterResultStackView: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        guard model.valute.count > pickerView.selectedRow(inComponent: 0) else { return }
        
        let selectedCurrencyByPicker = model.valute[pickerView.selectedRow(inComponent: 0)]
        
        if textField.text != selectedCurrencyByPicker.charCode {
            selectProperRow()
        }
    }
}
