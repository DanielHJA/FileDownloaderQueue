//
//  ViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadsViewController: BaseTableviewViewController<DownloadObject, DownloadTableViewCell> {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.post("FetchDownloadObjects")
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.register(DownloadTableViewCell.self, forCellReuseIdentifier: "DownloadTableViewCell")
    }
    
    @objc override func fetchObjects() {
        let predicate: NSPredicate? = NSPredicate(format: "finished = %d", false)
        Core.shared.fetch(DownloadObject.self, predicate: predicate) { (results) in
            self.items = results
        }
        reload()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }
    
}

extension NotificationCenter {
    static func post(_ name: String) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: name), object: nil) 
    }
}
