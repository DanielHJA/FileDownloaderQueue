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
        guard let object = object else { return }
        if let resumeData = Storage.shared.fetchResumeDataForFile(object.name) {
            downloadTask = session?.downloadTask(withResumeData: resumeData)
        }
    }
    
    func suspendDownloadTask() {
        guard let object = object else { return }
        object.isRunning = false
        downloadTask?.cancel(byProducingResumeData: { (data) in
            Storage.shared.storeResumeData(data, name: object.name)
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
        guard let object = object else { return }
        Storage.shared.saveFileFromTemporaryLocation(location, filename: object.name)
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

class Storage {
    static let shared = Storage()
    
    private var manager = FileManager.default
    
    private var defaultDirectory: URL? {
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveFileFromTemporaryLocation(_ tempLocation: URL, filename: String) {
        guard let defaultDirectory = defaultDirectory else { return }
        let newLocation = defaultDirectory.appendingPathComponent(filename)
        
        if fileExist(filename, location: defaultDirectory) {
            print("File exists")
        } else {
            do {
                try manager.copyItem(at: tempLocation, to: newLocation)
            } catch {
                print(error)
            }
        }
    }
    
    func fileExist(_ filename: String, location: URL?) -> Bool {
        guard let filePath = location?.appendingPathComponent(filename).path else { return false }
        return manager.fileExists(atPath: filePath)
    }
    
    func fetchResumeDataForFile(_ filename: String) -> Data? {
        guard let defaultDirectory = defaultDirectory else { return nil }
        let resumeDataDirectoryLocation = defaultDirectory.appendingPathComponent("resumedata")
        let resumeDataLocation = resumeDataDirectoryLocation.appendingPathComponent("\(filename).resumedata")
        do {
            let data = try Data(contentsOf: resumeDataLocation)
            return data
        } catch {
            print(error)
        }
        return nil
    }

    func storeResumeData(_ data: Data?, name: String) {
        guard let defaultDirectory = defaultDirectory else { return }
        let resumeDataDirectoryLocation = defaultDirectory.appendingPathComponent("resumedata")
        let resumeDataLocation = resumeDataDirectoryLocation.appendingPathComponent("\(name).resumedata")
        
        if fileExist("resumedata", location: defaultDirectory) {
            do {
                try data?.write(to: resumeDataLocation)
            } catch {
                print(error)
            }
        } else {
            do {
                try manager.createDirectory(at: resumeDataDirectoryLocation, withIntermediateDirectories: false, attributes: [:])
            } catch {
                print(error)
            }
        }
    }
    
}
