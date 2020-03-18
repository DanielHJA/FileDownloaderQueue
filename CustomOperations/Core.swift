//
//  Core.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-17.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData

class Core: NSObject {
    static let shared = Core()
    
    override private init() {}
    
    private var appDelegate: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    
    lazy var context: NSManagedObjectContext = {
        return appDelegate.persistentContainer.viewContext
    }()
    
    func create<T: NSManagedObject>() -> T? {
        guard let entityDescription = T.entityDescription else { return nil }
        let object = T(entity: entityDescription, insertInto: context)
        return object
    }
    
    func add(_ object: NSManagedObject) {
        context.insert(object)
        saveContext()
    }
    
    func fetch<T: NSManagedObject>(_ entity: T.Type, predicate: NSPredicate?, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: entity.entityName)
        request.returnsObjectsAsFaults = false
        request.predicate = predicate
        
        do {
            let results = try context.fetch(request)
            completion(results)
        } catch {
            print(error)
        }
    }
    
    func objectExist<T: NSManagedObject>(_ type: T.Type, object: Download) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: T.entityName)
        request.includesSubentities = false
        let predicate = NSPredicate(format: "id = %@", object.id)
        request.predicate = predicate

        do {
            let count = try context.count(for: request)
            return count > 0
        } catch {
            print(error)
            return false
        }
    }
    
    func convertDownloadsToCoreObjects(_ downloads: [Download]) {
        downloads.forEach {
            if !objectExist(DownloadObject.self, object: $0) {
                if let downloadObject: DownloadObject = Core.shared.create() {
                    downloadObject.id = $0.id
                    downloadObject.name = $0.name
                    downloadObject.downloadURL = $0.url
                    downloadObject.progress = $0.progress
                    downloadObject.type = $0.type.rawValue
                    downloadObject.finished = false
                    Core.shared.add(downloadObject)
                }
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        context.delete(object)
        saveContext()
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
}
