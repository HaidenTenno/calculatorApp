//
//  ConverterScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import SideMenu

class ConverterScreenViewController: UIViewController {

    //UI
    private var globalStackView: UIStackView!
    private var swipableStackView: UIStackView!
    private var editableStackView: ConverterResultStackView!
    private var swapButtonStackView: UIStackView!
    private var swapButton: UIButton!
    private var blankView: UIView!
    private var notEditableStackView: ConverterResultStackView!
    private var collectionView: UICollectionView!
    
    //Model
    let model = ConverterModel()

    private var apiAnswer: ConverterApiAnswer?

    //Services
    private var dataFetcher: NetworkDataFetcher = NetworkDataFetcherImplementation.shared
    var converterService: Converter = ConverterImplementation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        
        LoadingIndicatorView.show()
        dataFetcher.delegate = self
        dataFetcher.fetchCurrencyInfo()
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
        let navImage = UIImage(systemName: Config.StringConsts.Images.horisontalLines)?
            .withTintColor(Config.Design.Colors.buttonText)
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
        
        //editableStackView
        editableStackView = ConverterResultStackView()
        swipableStackView.addArrangedSubview(editableStackView)
        editableStackView.delegate = self
        editableStackView.converterVC = self
        editableStackView.configure(editable: true)
        
        //swapButtonStackView
        swapButtonStackView = UIStackView()
        swapButtonStackView.axis = .horizontal
        swapButtonStackView.distribution = .fill
        swapButtonStackView.alignment = .leading
        swipableStackView.addArrangedSubview(swapButtonStackView)
        
        //swapButton
        swapButton = UIButton(type: .system)
        let swapImage = UIImage(systemName: Config.StringConsts.Images.arrowUpDown)?
            .withTintColor(Config.Design.Colors.buttonText)
            .withRenderingMode(.alwaysOriginal)
        swapButton.setImage(swapImage, for: .normal)
        swapButton.contentHorizontalAlignment = .left
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        swapButtonStackView.addArrangedSubview(swapButton)
        
        //blankView
        blankView = UIView()
        swapButtonStackView.addArrangedSubview(blankView)
        
        //notEditableStackView
        notEditableStackView = ConverterResultStackView()
        swipableStackView.addArrangedSubview(notEditableStackView)
        notEditableStackView.delegate = self
        notEditableStackView.converterVC = self
        notEditableStackView.configure(editable: false)
        
        //collectionView
        let collectionViewLayout = UICollectionViewFlowLayout()
        collectionViewLayout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout)
        collectionView.register(CalculatorCollectionViewCell.self, forCellWithReuseIdentifier: Config.StringConsts.collectionViewID)
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
        
        //editableStackView
        editableStackView.snp.makeConstraints { make in
            make.left.equalTo(swipableStackView)
            make.right.equalTo(swipableStackView)
            make.height.equalTo(70)
        }
        editableStackView.makeConstraints()
        
        //swapButtonStackView
        swapButtonStackView.snp.makeConstraints { make in
            make.left.equalTo(swipableStackView).offset(5)
            make.right.equalTo(swipableStackView).offset(-5)
        }
        
        //notEditableStackView
        notEditableStackView.snp.makeConstraints { make in
            make.left.equalTo(swipableStackView)
            make.right.equalTo(swipableStackView)
            make.height.equalTo(70)
        }
        notEditableStackView.makeConstraints()
        
        //collectionView
        collectionView.snp.makeConstraints { make in
            make.left.equalTo(globalStackView)
            make.right.equalTo(globalStackView)
        }
    }
    
    private func converterButtonTapped(item: CalculatorButtonItem) {
        converterService.handleAction(of: item)
        fillData()
    }
    
    private func fillData() {
        editableStackView.reloadData()
        notEditableStackView.reloadData()
    }
    
    @objc private func swipeDown() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func swipeUp() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    @objc private func swapButtonTapped() {
        let rememberedCurrency = model.firstSelectedCurrency
        let rememberedValue = converterService.firstStrResult
        
        model.firstSelectedCurrency = model.secondSelectedCurrency
        model.secondSelectedCurrency = rememberedCurrency
        
        converterService.firstCurrency = model.firstSelectedCurrency
        converterService.secondCurrency = model.secondSelectedCurrency
        
        converterService.firstStrResult = rememberedValue
        
        fillData()
    }
    
    @objc private func showMenuButtonTapped() {
        
        let sideMenuTableViewController = SideMenuTableViewController()
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.model = SideMenuTableViewModel(activeType: .converter)
        
        let menu = SideMenuNavigationController(rootViewController: sideMenuTableViewController)
        menu.statusBarEndAlpha = 0
        menu.presentationStyle = .viewSlideOut
        
        present(menu, animated: true, completion: nil)
    }
    
    @objc private func resultSwipedToLeft() {
        converterService.removeLast()
        fillData()
    }
}

extension ConverterScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Config.Design.CalculatorButtonSize.width, height: Config.Design.CalculatorButtonSize.hight)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Config.StringConsts.collectionViewID, for: indexPath) as! CalculatorCollectionViewCell
        cell.item = model.items[indexPath.row]
        cell.calculatorButton = UIButton(type: .system)
        
        //Действие по нажатию кнопки
        cell.tapButtonAction = { [weak self] item in
            guard let strongSelf = self else { return }
            strongSelf.converterButtonTapped(item: item)
        }
        return cell
    }
}

extension ConverterScreenViewController: SideMenuTableViewControllerDelegate {
    
    func sideMenuTableViewController(_ sideMenuTableViewController: SideMenuTableViewController, didSelect mode: SideMenuTableViewModelItemType) {
        
        guard var viewControllers = navigationController?.viewControllers else { return }
        _ = viewControllers.popLast()
                
        switch mode {
        case .calculator:
            viewControllers.append(CalculatorScreenViewController())
        case .converter:
            viewControllers.append(ConverterScreenViewController())
        }
        
        navigationController?.setViewControllers(viewControllers, animated: true)
    }
}

extension ConverterScreenViewController: ConverterResultStackViewDelegate {
    
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewFirstCurrency: Currency) {
        converterService.firstCurrency = model.firstSelectedCurrency
        fillData()
    }
    
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewSecondCurrency: Currency) {
        converterService.secondCurrency = model.secondSelectedCurrency
        fillData()
    }
    
    func converterResultStackViewSwipedLeft(_ converterResultStackView: ConverterResultStackView) {
        resultSwipedToLeft()
    }    
}

extension ConverterScreenViewController: NetworkDataFetcherDelegate {
    
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, didFetch data: ConverterApiAnswer) {
        
        LoadingIndicatorView.hide()
        model.setValute(data.valute)
        
        converterService.firstCurrency = model.firstSelectedCurrency
        converterService.secondCurrency = model.secondSelectedCurrency
                
        fillData()
    }
    
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, failedWith error: Error) {
        
        LoadingIndicatorView.hide()
        #if DEBUG
        print("Fetching data error: \(error.localizedDescription)")
        #endif
    }
}
