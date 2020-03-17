//
//  FileDownloadManager.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol FileDownloaderFinishDelegate: class {
    func downloadOperationDidFinish()
}

protocol FileDownloaderDelegate: class {
    func updateProgress(_ progress: Float)
}

class FileDownloader: NSObject, URLSessionDelegate, URLSessionDownloadDelegate {
    
    weak var finishDelegate: FileDownloaderFinishDelegate?
    weak var delegate: FileDownloaderDelegate?
    weak var object: Download?
    
    private var session: URLSession?
    private var downloadTask: URLSessionDownloadTask?
    private var configuration: URLSessionConfiguration {
        let temp = URLSessionConfiguration.default
        return temp
    }
    
    required init(_ object: Download) {
        super.init()
        guard let url = object.url else { return }
        self.object = object
        let request = URLRequest(url: url)
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.current)
        downloadTask = session?.downloadTask(with: request)
    }
    
    func resumeDownloadTask() {
        setResumeDataIfExist()
        object?.isRunning = true
        downloadTask?.resume()
    }
    
    private func setResumeDataIfExist() {
        if let resumeData = object?.resumeData {
            downloadTask = session?.downloadTask(withResumeData: resumeData)
        }
    }
    
    func suspendDownloadTask() {
        object?.isRunning = false
        downloadTask?.cancel(byProducingResumeData: { (data) in
            self.object?.resumeData = data
        })
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        if self.object?.isRunning ?? false {
            DispatchQueue.main.async { [weak self] in
                self?.delegate?.updateProgress(progress)
            }
        }
        
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        print("Download completed")
        object?.isRunning = false
        finishDelegate?.downloadOperationDidFinish()
    }
    
}
