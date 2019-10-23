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
    
    // UI Элементы
    private var globalStackView: UIStackView!
    private var swipableStackView: UIStackView!
    private var resultLabel: UILabel!
    private var modeLabel: UILabel!
    private var collectionView: UICollectionView!
    
    // Модель
    private let model = CalculatorViewModel()
    
    // Сервисы
    private var calculatorService: Calculator = CalculatorDQWrapper()
    private var presenterService = NumberPresenterService(style: .calculator)
    
    // Текст для отображения
    private var textToShow: String? {
        didSet {
            guard let textToShow = textToShow else { return }
            resultLabel.text = presenterService.format(string: textToShow)
        }
    }
    
    // Колбек для обработки нажатия кнопки меню
    private var onShowMenuTapped: ((SideMenuTableViewModelItemType) -> Void)
    
    init(onShowMenuTapped: @escaping (SideMenuTableViewModelItemType) -> Void) {
        self.onShowMenuTapped = onShowMenuTapped
        calculatorService.delegate = model
        super.init(nibName: nil, bundle: nil)
        model.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        makeConstraints()
    }
    
    // MARK: - UI
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
        modeLabel.text = model.mode.stringValue
        modeLabel.font = UIFont(name: Config.Design.fontName, size: 20)
        modeLabel.textColor = Config.Design.Colors.label
        modeLabel.textAlignment = .left
        modeLabel.numberOfLines = 0
        modeLabel.isUserInteractionEnabled = true
        swipableStackView.addArrangedSubview(modeLabel)
        
        //resultLabel
        resultLabel = UILabel()
        textToShow = model.strValue
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
}
// MARK: - Обработчики жестов и нажатий
extension CalculatorScreenViewController {
    
    private func roundButtonTapped(item: RoundButtonItem) {
        // Обновить collectionView после обработки нажатия (чтобы подсветить кнопку с операцией и режимом)
        calculatorService.handleAction(of: item) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.collectionView.reloadData()
        }
    }
    
    @objc private func resultSwipedToLeft() {
        calculatorService.removeLast()
    }
    
    @objc private func swipeDown() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func swipeUp() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func showMenuButtonTapped() {
        onShowMenuTapped(.calculator)
    }
}

// MARK: - CalculatorViewModelDelegate
extension CalculatorScreenViewController: CalculatorViewModelDelegate {
    
    func calculatorViewModelDidUpdateValue(_ viewModel: CalculatorViewModel) {
        textToShow = viewModel.strValue
    }
    
    func calculatorViewModelDidUpdateMode(_ viewModel: CalculatorViewModel) {
        modeLabel.text = viewModel.mode.stringValue
    }
}

// MARK: - UpdatableOnRotation
extension CalculatorScreenViewController: UpdatableOnRotation {
    
    func updateView() {
        guard let textToShow = textToShow else { return }
        resultLabel.text = presenterService.format(string: textToShow)
    }
}


// MARK: - CollectionView
extension CalculatorScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.Design.RoundButtonSize.width, height: Config.Design.RoundButtonSize.hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.StringID.collectionViewID, for: indexPath) as! ButtonsCollectionViewCell
        cell.configure(item: model.items[indexPath.row], roundButton: UIButton(type: .system)) { [weak self] item in
            guard let strongSelf = self else { return }
            strongSelf.roundButtonTapped(item: item)
        }
        
        return cell
    }
}
