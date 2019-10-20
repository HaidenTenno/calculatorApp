//
//  ViewsCoordinator.swift
//  calculatorApp
//
//  Created by Петр Тартынских on 16.10.2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit
import SideMenu

final class ViewsCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        NotificationCenter.default.addObserver(self, selector: #selector(deviceRotationChanged), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func start() {
        showCalculatorScreen()
    }
    
    func showCalculatorScreen() {
        let destinationVC = createCalculatorScreen()
        navigationController.pushViewController(destinationVC, animated: false)
    }
    
    func showConverterScreen() {
        let destinationVC = createConverterScreen()
        navigationController.pushViewController(destinationVC, animated: false)
    }
    
    private func createCalculatorScreen() -> CalculatorScreenViewController {
        let calculatorVC = CalculatorScreenViewController(onShowMenuTapped: showMenuButtonTapped(activeType:))
        return calculatorVC
    }
    
    private func createConverterScreen() -> ConverterScreenViewController {
        let converterVC = ConverterScreenViewController(onShowMenuTapped: showMenuButtonTapped(activeType:))
        return converterVC
    }
    
    private func showMenuButtonTapped(activeType: SideMenuTableViewModelItemType) {
        
        let sideMenuTableViewController = SideMenuTableViewController()
        sideMenuTableViewController.delegate = self
        sideMenuTableViewController.model = SideMenuTableViewModel(activeType: activeType)
        
        let menu = SideMenuNavigationController(rootViewController: sideMenuTableViewController)
        menu.statusBarEndAlpha = 0
        menu.presentationStyle = .viewSlideOut
        
        navigationController.present(menu, animated: true, completion: nil)
    }
    
    @objc private func deviceRotationChanged() {
        navigationController.viewControllers.forEach {
            ($0 as? UpdatableOnRotation)?.updateView()
        }
    }
}

extension ViewsCoordinator: SideMenuTableViewControllerDelegate {
    
    func sideMenuTableViewController(_ sideMenuTableViewController: SideMenuTableViewController, didSelect mode: SideMenuTableViewModelItemType) {
        
        var viewControllers = navigationController.viewControllers
        _ = viewControllers.popLast()
        
        switch mode {
        case .calculator:
            let calculatorVC = createCalculatorScreen()
            viewControllers.append(calculatorVC)
            
        case .converter:
            let converterVC = createConverterScreen()
            viewControllers.append(converterVC)
        }
        
        navigationController.setViewControllers(viewControllers, animated: true)
    }
}
