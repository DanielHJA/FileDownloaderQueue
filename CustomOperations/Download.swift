//
//  Download.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum FileType: String, Decodable {
    case zip
    case pdf
    case jpg
}

protocol DownloadObjectDelegate: class {
    func updateProgress(_ progress: Float)
}

class Download: Codable {
    
    weak var delegate: DownloadObjectDelegate?
    
    let id: String
    let name: String
    let type: FileType
    let url: URL?
    var progress: Float = 0
    var isRunning: Bool = false
    var resumeData: Data?
    
    private enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case url = "url"
        case progress = "progress"
        case isRunning = "isRunning"
        case resumeData = "resumeData"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        type = try container.decode(FileType.self, forKey: .type)
        url = try container.decode(URL.self, forKey: .url)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(url, forKey: .url)
        try container.encode(progress, forKey: .progress)
        try container.encode(isRunning, forKey: .isRunning)
        try container.encode(resumeData, forKey: .resumeData)
    }
    
    init(id: String, name: String, type: FileType, url: URL?) {
        self.id = id
        self.name = name
        self.type = type
        self.url = url
    }
    
}

//extension Download: FileDownloaderDelegate {
//    func updateProgress(_ progress: Float) {
//        self.progress = progress
//        delegate?.updateProgress(progress)
//    }
//}
