//
//  BaseTableViewCell.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class BaseTableViewCell<T: Decodable>: UITableViewCell {
    
    var object: T!
    
    func configure(_ object: T) {
        self.object = object
    }
    
}

extension BaseTableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

