//
//  Extensions.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//
import Foundation
import CoreData
import UIKit

extension Encodable {
    func encode() -> Data? {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(self)
            return data
        } catch let error {
            print(error)
        }
        return nil
    }
}

extension Array where Element : Codable {
    func encode() -> [Data] {
        return compactMap { $0.encode() }
    }
}

extension Array where Element == Data {
    func toJson() -> [String] {
        return compactMap { String(data: $0, encoding: .utf8) }
    }
}

extension Data {
    func decode<T: Decodable>() -> T? {
        let decoder = JSONDecoder()
        do {
            let objects = try decoder.decode(T.self, from: self)
            return objects
        } catch {
            print(error)
            return nil
        }
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

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}
