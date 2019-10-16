//
//  CalculatorScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import SnapKit

class CalculatorScreenViewController: UIViewController {
    
    //UI
    private var globalStackView: UIStackView!
    private var swipableStackView: UIStackView!
    private var resultLabel: UILabel!
    private var modeLabel: UILabel!
    private var collectionView: UICollectionView!
    
    //Model
    private let model = CalculatorViewModel()
    
    //Services
    private var calculatorService: Calculator = CalculatorImplementation()
    private var presenterService = NumberPresenterService(style: .calculator)
    
    private var textToShow: String? {
        didSet {
            guard let textToShow = textToShow else { return }
            resultLabel.text = presenterService.format(string: textToShow)
        }
    }
    
    var onShowMenuTapped: ((SideMenuTableViewModelItemType) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        calculatorService.delegate = model
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        makeConstraints()
    }
    
    private func setupView() {
        
        //view
        view.backgroundColor = Config.Design.Colors.backgroud
        
        //navigationController
        navigationItem.rightBarButtonItems = []
        let image = UIImage(systemName: Config.Design.Images.horisontalLines)?
            .withTintColor(Config.Design.Colors.buttonText)
            .withRenderingMode(.alwaysOriginal)
        let showMenuButton = UIButton(type: .system)
        showMenuButton.setImage(image, for: .normal)
        showMenuButton.addTarget(self, action: #selector(showMenuButtonTapped), for: .touchUpInside)
        navigationItem.rightBarButtonItems?.append(UIBarButtonItem(customView: showMenuButton))
        
        //globalStackView
        globalStackView = UIStackView()
        globalStackView.axis = .vertical
        globalStackView.distribution = .fill
        globalStackView.alignment = .center
        view.addSubview(globalStackView)
        
        //swipableStackView
        swipableStackView = UIStackView()
        swipableStackView.axis = .vertical
        swipableStackView.distribution = .fill
        swipableStackView.alignment = .center
        //Hide/Show NavBar
        let swipeDownGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeDown))
        let swipeUpGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipeUp))
        swipeDownGesture.direction = UISwipeGestureRecognizer.Direction.down
        swipeUpGesture.direction = UISwipeGestureRecognizer.Direction.up
        swipableStackView.addGestureRecognizer(swipeDownGesture)
        swipableStackView.addGestureRecognizer(swipeUpGesture)
        globalStackView.addArrangedSubview(swipableStackView)
        
        //modeLabel
        modeLabel = UILabel()
        modeLabel.text = calculatorService.mode.rawValue
        modeLabel.font = UIFont(name: Config.Design.fontName, size: 20)
        modeLabel.textColor = Config.Design.Colors.label
        modeLabel.textAlignment = .left
        modeLabel.numberOfLines = 0
        modeLabel.isUserInteractionEnabled = true
        swipableStackView.addArrangedSubview(modeLabel)
        
        //resultLabel
        resultLabel = UILabel()
        textToShow = calculatorService.strValue
        resultLabel.font = UIFont(name: Config.Design.fontName, size: 70)
        resultLabel.textColor = Config.Design.Colors.label
        resultLabel.textAlignment = .right
        resultLabel.adjustsFontSizeToFitWidth = true
        resultLabel.minimumScaleFactor = 0
        resultLabel.numberOfLines = 1
        resultLabel.isUserInteractionEnabled = true
        //Remove last gesture
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(resultSwipedToLeft))
        swipeLeftGesture.direction = UISwipeGestureRecognizer.Direction.left
        resultLabel.addGestureRecognizer(swipeLeftGesture)
        swipableStackView.addArrangedSubview(resultLabel)
        
        //collectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(ButtonsCollectionViewCell.self, forCellWithReuseIdentifier: Config.StringID.collectionViewID)
        collectionView.backgroundColor = Config.Design.Colors.backgroud
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
        
        //swipableStackView
        swipableStackView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
        
        //modeLabel
        modeLabel.snp.makeConstraints { make in
            make.left.equalTo(swipableStackView)
            make.right.equalTo(swipableStackView)
        }
        
        //resultLabel
        resultLabel.snp.makeConstraints { make in
            make.left.equalTo(swipableStackView)
            make.right.equalTo(swipableStackView)
            make.height.equalTo(100)
        }
        
        //collectionView
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
    }
    
    private func calculatorButtonTapped(item: RoundButtonItem) {
        
        calculatorService.handleAction(of: item)
        textToShow = calculatorService.strValue
        modeLabel.text = calculatorService.mode.rawValue
        
        collectionView.reloadData()
    }
    
    @objc private func resultSwipedToLeft() {
        
        calculatorService.removeLast()
        textToShow = calculatorService.strValue
    }
    
    @objc private func swipeDown() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func swipeUp() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func showMenuButtonTapped() {
        onShowMenuTapped?(.calculator)
    }
}

extension CalculatorScreenViewController: UpdatableOnRotation {
    
    func updateView() {
        guard let textToShow = textToShow else { return }
        resultLabel.text = presenterService.format(string: textToShow)
    }
}

extension CalculatorScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.Design.RoundButtonSize.width, height: Config.Design.RoundButtonSize.hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.StringID.collectionViewID, for: indexPath) as! ButtonsCollectionViewCell
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
