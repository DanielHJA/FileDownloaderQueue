//
//  FinishedDownloadTableViewCell.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class FinishedDownloadTableViewCell: BaseTableViewCell<DownloadObject> {
    
    private lazy var content: UIView = {
        let temp = UIView()
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10.0).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        return temp
    }()

    private lazy var label: UILabel = {
        let temp = UILabel()
        temp.textColor = UIColor.black
        temp.textAlignment = .left
        temp.numberOfLines = 1
        temp.lineBreakMode = .byTruncatingMiddle
        temp.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: content.leadingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: content.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: content.bottomAnchor).isActive = true
        temp.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7).isActive = true
        return temp
    }()

    override func configure(_ object: DownloadObject) {
        super.configure(object)
        accessoryType = .disclosureIndicator
        label.text = object.name
    }

}
