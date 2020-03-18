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
    weak var object: DownloadObject?
    
    private var session: URLSession?
    private var downloadTask: URLSessionDownloadTask?
    private var configuration: URLSessionConfiguration {
        let temp = URLSessionConfiguration.default
        return temp
    }
    
    required init(_ object: DownloadObject) {
        super.init()
        guard let url = object.downloadURL else { return }
        self.object = object
        let request = URLRequest(url: url) 
        session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.current)
        downloadTask = session?.downloadTask(with: request)
    }
    
    func resumeDownloadTask() {
        setResumeDataIfExist()
        object?.isRunning = true
        object?.save()
        downloadTask?.resume()
    }
    
    private func setResumeDataIfExist() {
        guard let object = object, let name = object.name else { return }
        
        if let resumeData = Storage.shared.fetchResumeDataForFile(name) {
            downloadTask = session?.downloadTask(withResumeData: resumeData)
        }
    }
    
    func suspendDownloadTask() {
        guard let object = object, let name = object.name else { return }
        object.isRunning = false
        downloadTask?.cancel(byProducingResumeData: { (data) in
            Storage.shared.storeResumeData(data, name: name)
        })
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        print(progress)
        if self.object?.isRunning ?? false {
            DispatchQueue.main.async { [weak self] in
                self?.object?.progress = progress
                self?.object?.save()
                self?.delegate?.updateProgress(progress)
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let object = object else { return }
        Storage.shared.saveFileFromTemporaryLocation(location, object: object)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print(error)
            return
        }
        print("Download completed")
        object?.isRunning = false
        object?.finished = true
        object?.save()
        finishDelegate?.downloadOperationDidFinish()
    }
    
}
