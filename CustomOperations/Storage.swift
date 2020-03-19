//
//  Storage.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-17.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class Storage {
    static let shared = Storage()
    
    private var manager = FileManager.default
    
    var defaultDirectory: URL? {
        return manager.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    func saveFileFromTemporaryLocation(_ tempLocation: URL, object: DownloadObject) {
        guard let defaultDirectory = defaultDirectory, let name = object.name, let type = object.type else { return }
        print(defaultDirectory)
        let newLocation = defaultDirectory.appendingPathComponent("\(name).\(type)")
        
        do {
            try manager.copyItem(at: tempLocation, to: newLocation)
        } catch {
            print(error)
        }
        
    }
    
    func locationExist(_ location: URL?) -> Bool {
        guard let location = location?.path else { return false }
        return manager.fileExists(atPath: location)
    }
    
    func fetchResumeDataForFile(_ filename: String) -> Data? {
        guard let defaultDirectory = defaultDirectory else { return nil }
        let resumeDataDirectoryLocation = defaultDirectory.appendingPathComponent("data")
        let resumeDataLocation = resumeDataDirectoryLocation.appendingPathComponent("\(filename).data")
        do {
            let data = try Data(contentsOf: resumeDataLocation)
            return data
        } catch {
            print(error)
        }
        return nil
    }
    
    func deleteFileForObject(_ object: DownloadObject?) {
        guard let url = urlForObject(object) else { return }
        
        do {
            try manager.removeItem(at: url)
        } catch {
            print(error)
        }
    }
    
    func urlForObject(_ object: DownloadObject?) -> URL? {
        guard let defaultDirectory = defaultDirectory else { return nil }
        guard let name = object?.name, let type = object?.type else { return nil }
        return defaultDirectory.appendingPathComponent("\(name).\(type)")
    }
    
    func dataForLocation(_ location: URL?) -> Data? {
        guard let location = location else { return nil }
        do {
            let data = try Data(contentsOf: location)
            return data
        } catch {
            print(error)
        }
        return nil
    }
    
    func printContentsOfDefaultDirectory() {
        guard let defaultDirectory = defaultDirectory else { return }
        do {
            let fileURLs = try manager.contentsOfDirectory(at: defaultDirectory.appendingPathComponent("data"), includingPropertiesForKeys: nil)
            print(fileURLs)
        } catch {
            print("Error while enumerating files \(defaultDirectory.path): \(error.localizedDescription)")
        }
    }
    
    func storeResumeData(_ data: Data?, name: String) {
        guard let defaultDirectory = defaultDirectory else { return }
        let resumeDataDirectoryLocation = defaultDirectory.appendingPathComponent("data")
        let resumeDataLocation = resumeDataDirectoryLocation.appendingPathComponent("\(name).data")
        
        do {
            
            if !locationExist(resumeDataDirectoryLocation) {
                try manager.createDirectory(at: resumeDataDirectoryLocation, withIntermediateDirectories: false, attributes: [:])
            }
            
            if locationExist(resumeDataLocation) {
                do {
                    try manager.removeItem(at: resumeDataLocation)
                } catch {
                    print(error)
                }
            }
            
            try data?.write(to: resumeDataLocation)
        } catch {
            print(error)
        }
    }
    
}

