//
//  BaseTableviewViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class BaseTableviewViewController<T: Codable, C: BaseTableViewCell<T>>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var barButtonItem: UIBarButtonItem = {
        let temp = UIBarButtonItem(title: "Details", style: .plain, target: self, action: #selector(encodeItems))
        return temp
    }()
    
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
        navigationItem.rightBarButtonItem = barButtonItem
        registerCells()
    }
    
    @objc private func encodeItems() {
        let json = items.encode()
        print(json.toJson())
    }
    
    func reload() {
        tableView.reloadData()
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
    
}

extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch let error {
            print(error)
        }
        return nil
    }
}

extension Array where Element : Codable {
    func encode() -> [Data] {
        return compactMap { $0.encode() }
    }
}

extension Array where Element == Data {
    func toJson() -> [String] {
        return compactMap { String(data: $0, encoding: .utf8) }
    }
}
