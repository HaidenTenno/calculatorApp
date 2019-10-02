//
//  SideMenuTableViewController.swift
//  calculatorApp
//
//  Created by Петр Тартынских  on 02/10/2019.
//  Copyright © 2019 Петр Тартынских . All rights reserved.
//

import UIKit

protocol SideMenuTableViewControllerDelegate: class {
    func sideMenuTableViewController(_ sideMenuTableViewController: SideMenuTableViewController, didSelect mode: SideMenuTableViewModelItemType)
}

class SideMenuTableViewController: UITableViewController {

    private let model = SideMenuTableViewModel()
    
    weak var delegate: SideMenuTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Config.sideMenuTableViewID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return model.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Config.sideMenuTableViewID, for: indexPath)

        cell.textLabel?.text = model.items[indexPath.row].type.rawValue

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.delegate?.sideMenuTableViewController(strongSelf, didSelect: strongSelf.model.items[indexPath.row].type)
        }
    }

}
