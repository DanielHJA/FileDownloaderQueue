//
//  ViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class ViewController: BaseTableviewViewController<Download, DownloadTableViewCell> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        items = MockData.mockDownloads
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

