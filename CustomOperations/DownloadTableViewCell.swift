//
//  DownloadTableViewCell.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class DownloadTableViewCell: BaseTableViewCell<DownloadObject>, DownloadObjectDelegate {
    
    private var operation: DownloadOperation?
    
    private lazy var content: UIView = {
        let temp = UIView()
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10.0).isActive = true
        temp.topAnchor.constraint(equalTo: topAnchor, constant: 10.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: progressView.topAnchor, constant: -5.0).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10.0).isActive = true
        return temp
    }()
    
    private lazy var progressView: UIProgressView = {
        let temp = UIProgressView()
        temp.backgroundColor = .lightGray
        temp.progressTintColor = .green
        temp.progress = 0
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5.0).isActive = true
        temp.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5.0).isActive = true
        temp.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
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
        temp.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5).isActive = true
        return temp
    }()
    
    private lazy var downloadButton: UIButton = {
        let temp = UIButton()
        temp.setTitle("Download", for: .normal)
        temp.layer.cornerRadius = 5.0
        temp.setTitleColor(UIColor.white, for: .normal)
        temp.addTarget(self, action: #selector(didPressDownloadButton), for: .touchUpInside)
        temp.backgroundColor = UIColor.blue
        addSubview(temp)
        temp.translatesAutoresizingMaskIntoConstraints = false
        temp.trailingAnchor.constraint(equalTo: content.trailingAnchor).isActive = true
        temp.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        temp.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        temp.widthAnchor.constraint(greaterThanOrEqualToConstant: 90.0).isActive = true
        return temp
    }()
    
    override func configure(_ object: DownloadObject) {
        super.configure(object)
        self.object = object
//        object.delegate = self
        label.text = object.name
        progressView.setProgress(object.progress, animated: false)
        downloadButton.isHidden = false
    }
    
    @objc private func didPressDownloadButton() {
        downloadButton.removeTarget(self, action: #selector(didPressDownloadButton), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(didPressPauseButton), for: .touchUpInside)
        downloadButton.setTitle("Pause", for: .normal)
        object.isRunning = true
        configureDownloadTask()
        resumeDownloadTask()
    }
    
    @objc private func didPressPauseButton() {
        downloadButton.removeTarget(self, action: #selector(didPressPauseButton), for: .touchUpInside)
        downloadButton.addTarget(self, action: #selector(didPressDownloadButton), for: .touchUpInside)
        downloadButton.setTitle("Download", for: .normal)
        object.isRunning = false
        suspendDownloadTask()
    }
    
    private func configureDownloadTask() {
        DownloadOperationsManager.shared.createDownloadTaskForURL(self, object) { (operation) in
            self.operation = operation
        }
    }
    
    private func resumeDownloadTask() {
        DownloadOperationsManager.shared.resumeOperation(operation)
    }
    
    private func suspendDownloadTask() {
        DownloadOperationsManager.shared.cancelOperation(operation)
    }
    
}

extension DownloadTableViewCell: FileDownloaderDelegate {
    func updateProgress(_ progress: Float) {
        progressView.setProgress(progress, animated: true)
    }
}
