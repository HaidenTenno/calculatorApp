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

    private var globalStackView: UIStackView!
    private var resultLabel: UILabel!
    private var collectionView: UICollectionView!
    private var calculatorButtons = CalculatorButtonValue.allCases
    
    private let calculatorService = CalculatorImplementation.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
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
        view.backgroundColor = .systemIndigo
        
        //globalStackView
        globalStackView = UIStackView()
        globalStackView.axis = .vertical
        globalStackView.distribution = .fill
        globalStackView.alignment = .center
        view.addSubview(globalStackView)
        
        //resultLabel
        resultLabel = UILabel()
        resultLabel.text = "0"
        resultLabel.font = .systemFont(ofSize: 50)
        resultLabel.textAlignment = .right
        globalStackView.addArrangedSubview(resultLabel)
        
        //collectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: Config.collectionViewID)
        collectionView.backgroundColor = .systemIndigo
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
        
        //resultLabel
        resultLabel.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
            make.height.greaterThanOrEqualTo(100)
        }
        
        //collectionView
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
    }
    
    private func calculatorButtonTapped(item: CalculatorCollectionViewCell) {
        
        switch item.calculatorButtonType {
        case .number:
            print("number: \(item.calculatorButtonValue.rawValue)")
        case .operation:
            print("oper: \(item.calculatorButtonValue.rawValue)")
        case .none:
            fatalError()
        }
    }
}

extension MainScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.CalculatorButtonSize.width, height: Config.CalculatorButtonSize.hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calculatorButtons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.collectionViewID, for: indexPath) as! CalculatorCollectionViewCell
        cell.calculatorButtonValue = calculatorButtons[indexPath.row]
        cell.calculatorButton = UIButton(type: .system)
        
        //Действие по нажатию кнопки
        cell.tabButtonAction = { [weak self] item in
            guard let strongSelf = self else { return }
            strongSelf.calculatorButtonTapped(item: item)
        }
        return cell
    }
}
