//
//  DownloadOperationsManager.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadOperationsManager: NSObject {
    static let shared = DownloadOperationsManager()

    private var queue: OperationQueue = {
        let temp = OperationQueue()
        temp.maxConcurrentOperationCount = 2
        return temp
    }()

    func createDownloadTaskForURL(_ cell: DownloadTableViewCell, _ object: DownloadObject, completion: @escaping (DownloadOperation) -> Void) {
        let downloader = FileDownloader(object)
        downloader.delegate = cell
        let operation = DownloadOperation(downloader)
        completion(operation)
    }
    
    func resumeOperation(_ operation: DownloadOperation?) {
        guard let operation = operation else { return }
        queue.addOperation(operation)
    }
    
    func cancelOperation(_ operation: DownloadOperation?) {
        guard let operation = operation else { return }
        operation.cancel()
    }

}
