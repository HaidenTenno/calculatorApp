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

    var model: SideMenuTableViewModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: SideMenuTableViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Config.sideMenuTableViewID)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let model = model else { return 0 }
        return model.items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = model else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Config.sideMenuTableViewID, for: indexPath)

        cell.textLabel?.font = UIFont(name: Config.fontName, size: 25)
        cell.textLabel?.textColor = Config.Colors.label
        cell.textLabel?.text = model.items[indexPath.row].type.rawValue

        cell.isUserInteractionEnabled = model.items[indexPath.row].active
        cell.textLabel?.isEnabled = model.items[indexPath.row].active
        cell.detailTextLabel?.isEnabled = model.items[indexPath.row].active
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
                
        dismiss(animated: true) { [weak self] in
            guard let strongSelf = self else { return }
            guard let strongModel = strongSelf.model else { return }
            
            strongSelf.delegate?.sideMenuTableViewController(strongSelf, didSelect: strongModel.items[indexPath.row].type)
        }
    }

}
