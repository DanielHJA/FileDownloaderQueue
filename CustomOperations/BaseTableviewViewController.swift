//
//  BaseTableviewViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData

class BaseTableviewViewController<T: NSManagedObject, C: BaseTableViewCell<T>>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var items = [T]()
    
    private(set) lazy var tableView: UITableView = {
        let temp = UITableView()
        temp.delegate = self
        temp.dataSource = self
        temp.tableFooterView = UIView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        return temp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchObjects), name: NSNotification.Name("DownloadDidFinish"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reload), name: NSNotification.Name("RefreshTableView"), object: nil)
    }
    
    @objc func fetchObjects() {}
    
    @objc func reload() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: C.identifier, for: indexPath) as? C else { return UITableViewCell() }
        let object = items[indexPath.row]
        cell.configure(object)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @available(iOS 11.0, *)
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return nil
    }
    
}
