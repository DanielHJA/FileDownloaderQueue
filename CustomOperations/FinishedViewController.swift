//
//  FinishedViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class FinishedViewController: BaseTableviewViewController<DownloadObject, FinishedDownloadTableViewCell> {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchObjects()
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.register(FinishedDownloadTableViewCell.self, forCellReuseIdentifier: "FinishedDownloadTableViewCell")
    }
    
    @objc override func fetchObjects() {
        let predicate: NSPredicate = NSPredicate(format: "finished = %d", true)
        Core.shared.fetch(DownloadObject.self, predicate: predicate) { (results) in
            self.items = results
        }
        reload()
    }
    
}
