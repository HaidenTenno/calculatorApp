//
//  MainScreenViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 29/09/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController {

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
        view.backgroundColor = .systemRed
    }
    
    private func makeConstraints() {
        
    }
}

