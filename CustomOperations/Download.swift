//
//  Download.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

protocol DownloadObjectDelegate: class {
    func updateProgress(_ progress: Float)
}

class Download: Codable {
    
    weak var delegate: DownloadObjectDelegate?
    
    let name: String
    let url: URL?
    var progress: Float = 0
    var isRunning: Bool = false
    var resumeData: Data?
    
    private enum CodingKeys: String, CodingKey {
        case name = "name"
        case url = "url"
        case progress = "progress"
        case isRunning = "isRunning"
        case resumeData = "resumeData"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        url = try container.decode(URL.self, forKey: .url)
        progress = try container.decode(Float.self, forKey: .progress)
        isRunning = try container.decode(Bool.self, forKey: .isRunning)
        resumeData = try container.decode(Data.self, forKey: .resumeData)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(progress, forKey: .progress)
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(resumeData, forKey: .resumeData)
    }
    
    init(name: String, url: URL?, progress: Float = 0) {
        self.name = name
        self.url = url
        self.progress = progress
    }
    
}

extension Download: FileDownloaderDelegate {
    func updateProgress(_ progress: Float) {
        self.progress = progress
        delegate?.updateProgress(progress)
    }
}
