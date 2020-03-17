//
//  MockData.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-13.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

class MockData: NSObject {
    
    static var mockDownloads: [Download] {
        return [
            Download(name: "100MB_File.zip",
                     url: URL(string: "http://ipv4.download.thinkbroadband.com/100MB.zip")),
            Download(name: "200MB_File.zip",
                     url: URL(string: "http://ipv4.download.thinkbroadband.com/200MB.zip")),
            Download(name: "50MB_File.zip",
                     url: URL(string: "http://ipv4.download.thinkbroadband.com/50MB.zip")),
            Download(name: "25MB_File.zip",
                     url: URL(string: "http://ipv4.download.thinkbroadband.com/25MB.zip"))
        ]
    }
    
}
