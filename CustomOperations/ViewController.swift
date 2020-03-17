//
//  ViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: BaseTableviewViewController<DownloadObject, DownloadTableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        items = MockData.mockDownloads
        Core.shared.fetch(DownloadObject.self) { (objects) in
            self.items = objects
        }
        
        reload()
    }
    
    override func registerCells() {
        super.registerCells()
        tableView.register(DownloadTableViewCell.self, forCellReuseIdentifier: "DownloadTableViewCell")
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90.0
    }


}

