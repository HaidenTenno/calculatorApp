//
//  ConverterScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class ConverterScreenViewController: UIViewController {
    
    // UI элементы
    private var globalStackView: UIStackView!
    private var swipableStackView: UIStackView!
    private var editableStackView: ConverterResultStackView!
    private var swapButtonStackView: UIStackView!
    private var swapButton: UIButton!
    private var notEditableStackView: ConverterResultStackView!
    private var collectionView: UICollectionView!
    
    // Модель
    private let model = ConverterViewModel()
    
    // Сервисы
    private var dataFetcher: NetworkDataFetcher = NetworkDataFetcherImplementation.shared
    private var converterService: Converter = ConverterDQWrapper()
    
    // Колбек для обработки нажатия кнопки меню
    private var onShowMenuTapped: ((SideMenuTableViewModelItemType) -> Void)
    
    init(onShowMenuTapped: @escaping (SideMenuTableViewModelItemType) -> Void) {
        self.onShowMenuTapped = onShowMenuTapped
        converterService.delegate = model
        super.init(nibName: nil, bundle: nil)
        model.delegate = self
        dataFetcher.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: - Implement better data fetching handling
        LoadingIndicatorView.show()
        // Imitating long data fetching
        _ = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { timer in
            self.dataFetcher.fetchCurrencyInfoXML()
        }
//        LoadingIndicatorView.show()
//        dataFetcher.fetchCurrencyInfoXML()
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
        let navImage = UIImage(systemName: Config.Design.Images.horisontalLines)?
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
        editableStackView = ConverterResultStackView(model: model, editable: true, delegate: self)
        swipableStackView.addArrangedSubview(editableStackView)
        
        //swapButtonStackView
        swapButtonStackView = UIStackView()
        swapButtonStackView.axis = .horizontal
        swapButtonStackView.distribution = .fill
        swapButtonStackView.alignment = .leading
        swipableStackView.addArrangedSubview(swapButtonStackView)
        
        //swapButton
        swapButton = UIButton(type: .system)
        let swapImage = UIImage(systemName: Config.Design.Images.arrowUpDown)?
            .withTintColor(Config.Design.Colors.buttonText)
            .withRenderingMode(.alwaysOriginal)
        swapButton.setImage(swapImage, for: .normal)
        swapButton.contentHorizontalAlignment = .left
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        swapButtonStackView.addArrangedSubview(swapButton)
        
        //blankView
        let blankView = UIView()
        swapButtonStackView.addArrangedSubview(blankView)
        
        //notEditableStackView
        notEditableStackView = ConverterResultStackView(model: model, editable: false, delegate: self)
        swipableStackView.addArrangedSubview(notEditableStackView)
        
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
    
}

// MARK: - Данные
extension ConverterScreenViewController {
    
    private func fillData() {
        editableStackView.reloadData()
        notEditableStackView.reloadData()
    }
}

// MARK: - Обработчики жестов и нажатий
extension ConverterScreenViewController {
    
    private func roundButtonTapped(item: RoundButtonItem) {
        converterService.handleAction(of: item)
    }
    
    @objc private func swipeDown() {
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc private func swipeUp() {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // TODO: - Manupulate service but not model
    @objc private func swapButtonTapped() {
        model.swapCurrency()
        converterService.firstCurrency = model.firstSelectedCurrency
        converterService.secondCurrency = model.secondSelectedCurrency
    }
    
    @objc private func showMenuButtonTapped() {
        onShowMenuTapped(.converter)
    }
    
    @objc private func resultSwipedToLeft() {
        converterService.removeLast()
    }
}

// MARK: - ConverterViewModelDelegate
extension ConverterScreenViewController: ConverterViewModelDelegate {
    
    func converterViewModelDidUpdateValue(_ viewModel: ConverterViewModel) {
        fillData()
    }
}

// MARK: - CollectionView
extension ConverterScreenViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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

// TODO: - Change to callbacks
// MARK: - ConverterResultStackViewDelegate
extension ConverterScreenViewController: ConverterResultStackViewDelegate {
    
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewFirstCurrency: XMLCurrency) {
        converterService.firstCurrency = model.firstSelectedCurrency
        fillData()
    }
    
    func converterResultStackView(_ converterResultStackView: ConverterResultStackView, didSelectNewSecondCurrency: XMLCurrency) {
        converterService.secondCurrency = model.secondSelectedCurrency
        fillData()
    }
    
    func converterResultStackViewSwipedLeft(_ converterResultStackView: ConverterResultStackView) {
        resultSwipedToLeft()
    }    
}

// MARK: - Data Fetcher
extension ConverterScreenViewController: NetworkDataFetcherDelegate {
    
    func networkDataFetcher(_ networkDataFecher: NetworkDataFetcher, didFetch parsedXML: [XMLCurrency]) {
        
        LoadingIndicatorView.hide()
        model.valute = parsedXML
        
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
