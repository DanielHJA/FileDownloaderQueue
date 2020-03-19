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
    
    @available(iOS 11.0, *)
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title: "Delete") { (action, view, completion) in
            completion(true)
            let object = self.items[indexPath.row]
            Core.shared.delete(object)
            Storage.shared.deleteFileForObject(object)
            self.items.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .left)
        }
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        super.tableView(tableView, didSelectRowAt: indexPath)
        let object = items[indexPath.row]
        guard let type = object.type, let filetype = FileType(rawValue: type) else { return }
        switch filetype {
        case .zip:
            return
        case .pdf:
            let controller = PDFViewController()
            controller.object = object
            navigationController?.pushViewController(controller, animated: true)
        case .jpg:
            let controller = ImageViewController()
            controller.object = object
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}
