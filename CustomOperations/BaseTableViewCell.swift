//
//  BaseTableViewCell.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit
import CoreData

class BaseTableViewCell<T: NSManagedObject>: UITableViewCell {
    
    var object: T!
    
    func configure(_ object: T) {
        self.object = object
    }
    
}
