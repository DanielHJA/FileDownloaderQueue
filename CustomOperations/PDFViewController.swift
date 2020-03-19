//
//  PDFViewController.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var object: DownloadObject?
    
    private lazy var pdfView: PDFView = {
        let temp = PDFView()
        view.addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        temp.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        temp.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        temp.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        return temp
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configurePDFDocument()
    }
    
    private func configurePDFDocument() {
        if let url = Storage.shared.urlForObject(object) {
            if let document = PDFDocument(url: url) {
                pdfView.autoScales = true
                pdfView.document = document
            }
        }
    }
    
}

