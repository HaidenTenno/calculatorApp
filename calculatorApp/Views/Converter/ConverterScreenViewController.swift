//
//  ConverterScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class ConverterScreenViewController: UIViewController {

    //UI
    private var globalStackView: UIStackView!
    private var editableStackView: ConverterResultStackView!
    private var swapButton: UIButton!
    private var notEditableStackView: ConverterResultStackView!
    private var collectionView: UICollectionView!
    
    //Model
    private let model = ConverterButtonModel()
    
    //Services
    private var converterService: Converter = ConverterImplementation.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        makeConstraints()
    }
    
    private func setupView() {
        
        //view
        view.backgroundColor = Config.Colors.backgroud
        
        //navigationController
        navigationItem.rightBarButtonItems = []
        let navImage = UIImage(systemName: "line.horizontal.3")?
            .withTintColor(Config.Colors.buttonText)
            .withRenderingMode(.alwaysOriginal)
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setImage(navImage, for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: showMenuButton))
        
        //globalStackView
        globalStackView = UIStackView()
        globalStackView.axis = .vertical
        globalStackView.distribution = .fill
        globalStackView.alignment = .center
        view.addSubview(globalStackView)
        
        //editableStackView
        editableStackView = ConverterResultStackView()
        globalStackView.addArrangedSubview(editableStackView)
        editableStackView.configure(editable: true)
        
        //swapButton
        swapButton = UIButton(type: .system)
        let swapImage = UIImage(systemName: "arrow.up.arrow.down")?
            .withTintColor(Config.Colors.buttonText)
            .withRenderingMode(.alwaysOriginal)
        swapButton.setImage(swapImage, for: .normal)
        swapButton.contentHorizontalAlignment = .left
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        globalStackView.addArrangedSubview(swapButton)
        
        //notEditableStackView
        notEditableStackView = ConverterResultStackView()
        globalStackView.addArrangedSubview(notEditableStackView)
        notEditableStackView.configure(editable: false)
        
        //collectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: Config.collectionViewID)
        collectionView.backgroundColor = Config.Colors.backgroud
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.delaysContentTouches = false
        globalStackView.addArrangedSubview(collectionView)
    }
    
    private func makeConstraints() {
        
        //globalStackView
        globalStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.left.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.right.equalTo(view.safeAreaLayoutGuide).offset(-10)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        //editableStackView
        editableStackView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
        
        //swapButtton
        swapButton.snp.makeConstraints { make in
            make.left.equalTo(globalStackView).offset(5)
            make.right.equalTo(globalStackView).offset(-5)
        }
        
        //notEditableStackView
        notEditableStackView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
        
        //collectionView
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
    }
    
    private func converterButtonTapped(item: CalculatorButtonNumberItem) {
                
        converterService.handleAction(of: item)
        
        collectionView.reloadData()
    }
    
    @objc private func swipeDown() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func swipeUp() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func showMenuButtonTapped() {
        print("Not implemented")
    }
    
    @objc private func swapButtonTapped() {
        print("Not implemented")
    }
    
}

extension ConverterScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.CalculatorButtonSize.width, height: Config.CalculatorButtonSize.hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.collectionViewID, for: indexPath) as! CalculatorCollectionViewCell
        cell.item = model.items[indexPath.row]
        cell.calculatorButton = UIButton(type: .system)
        
        //Действие по нажатию кнопки
        cell.tapButtonAction = { [weak self] item in
            guard let strongSelf = self else { return }
            guard let numberItem = item as? CalculatorButtonNumberItem else { return }
            strongSelf.converterButtonTapped(item: numberItem)
        }
        return cell
    }
}
