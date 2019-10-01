//
//  MainScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import SnapKit

class MainScreenViewController: UIViewController {
    
    //UI
    private var globalStackView: UIStackView!
    private var resultLabel: UILabel!
    private var modeLabel: UILabel!
    private var collectionView: UICollectionView!
    
    //Model
    private let model = CalculatorButtonModel()
    
    //Services
    private var calculatorService: Calculator = CalculatorImplementation.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        calculatorService.delegate = model
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        makeConstraints()
    }
    
    private func setupView() {
        
        //view
        view.backgroundColor = Config.Colors.backgroud
        
        //globalStackView
        globalStackView = UIStackView()
        globalStackView.axis = .vertical
        globalStackView.distribution = .fill
        globalStackView.alignment = .center
        view.addSubview(globalStackView)
        
        //modeLabel
        modeLabel = UILabel()
        modeLabel.text = calculatorService.mode.rawValue
        modeLabel.font = UIFont(name: Config.fontName, size: 20)
        modeLabel.textColor = Config.Colors.label
        modeLabel.textAlignment = .left
        modeLabel.numberOfLines = 0
        modeLabel.isUserInteractionEnabled = false
        globalStackView.addArrangedSubview(modeLabel)
        
        //resultLabel
        resultLabel = UILabel()
        resultLabel.text = calculatorService.strValue
        resultLabel.font = UIFont(name: Config.fontName, size: 100)
        resultLabel.textColor = Config.Colors.label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0
        resultLabel.numberOfLines = 0
        resultLabel.isUserInteractionEnabled = true
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(resultSwipedToLeft))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        resultLabel.addGestureRecognizer(swipeLeft)
        globalStackView.addArrangedSubview(resultLabel)
        
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
        
        //modeLabel
        modeLabel.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
        
        //resultLabel
        resultLabel.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
            make.height.equalTo(100)
        }
        
        //collectionView
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
    }
    
    private func calculatorButtonTapped(item: CalculatorButtonItem) {
                
        calculatorService.handleAction(of: item)
        resultLabel.text = calculatorService.strValue
        modeLabel.text = calculatorService.mode.rawValue
        
        collectionView.reloadData()
    }
    
    @objc private func resultSwipedToLeft() {
        
        calculatorService.removeLast()
        resultLabel.text = calculatorService.strValue
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            strongSelf.calculatorButtonTapped(item: item)
        }
        return cell
    }
}
