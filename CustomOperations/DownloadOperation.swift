//
//  DownloadOperation.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadOperation: Operation {
    
    var downloader: FileDownloader?
    
    enum OperationState : Int {
        case ready
        case executing
        case finished
    }
    
    // default state is ready (when the operation is created)
    private var state : OperationState = .ready {
        willSet {
            self.willChangeValue(forKey: "isExecuting")
            self.willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            self.didChangeValue(forKey: "isExecuting")
            self.didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isReady: Bool { return state == .ready }
    override var isExecuting: Bool { return state == .executing }
    override var isFinished: Bool { return state == .finished }
    
    init(_ downloader: FileDownloader) {
        super.init()
        self.downloader = downloader
        downloader.finishDelegate = self
    }
    
    override func start() {
        if(self.isCancelled) {
            state = .finished
            return
        }
        state = .executing
        downloader?.resumeDownloadTask()
    }
    
    override func cancel() {
        super.cancel()
        downloader?.suspendDownloadTask()
        state = .finished
    }
    
}

extension DownloadOperation: FileDownloaderFinishDelegate { 
    func downloadOperationDidFinish() {
        self.state = .finished
    }
}
