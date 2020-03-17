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

    func create<T: NSManagedObject>(for type: T.Type, completion: @escaping (T) -> Void) {
        guard let entityDescription = type.entityDescription else { return }
        let object = T(entity: entityDescription, insertInto: context)
        completion(object)
    }
    
    func add(_ object: NSManagedObject) {
        context.insert(object)
        saveContext()
    }
    
    func fetch<T: NSManagedObject>(_ entity: T.Type, completion: @escaping ([T]) -> Void) {
        let request = NSFetchRequest<T>(entityName: entity.entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            completion(results)
        } catch {
            print(error)
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
    
    func update(completion: @escaping () -> Void) {
        
    }
    
    
}

extension NSManagedObject {
    
    static var entityDescription: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: entityName, in: Core.shared.context)
    }
    
    static var entityName: String {
        return String(describing: self)
    }
    
    func save() {
        Core.shared.saveContext()
    }
    
}
