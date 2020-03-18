//
//  Webservice.swift
//  CustomOperations
//
//  Created by Daniel Hjärtström on 2020-03-18.
//  Copyright © 2020 Daniel Hjärtström. All rights reserved.
//

import UIKit

enum WebserviceError: Error {
    case badURI
    case decoding
    case system(Error)
    case server(Int)
    
    var localizedDescription: String {
        switch self {
        case .badURI:
            return "Something is wrong with the URL"
        case .decoding:
            return "Something went wrong when decoding"
        case .system(let error):
            return error.localizedDescription
        case .server(let statusCode):
            return "Something went wrong with the connection to the server. Statuscode: \(statusCode)"
        }
    }
    
    static func message(for error: WebserviceError) {
        print(error.localizedDescription)
    }
    
}

class Webservice<T: Decodable>: NSObject {

    static func fetch(urlString: String, completion: @escaping (Result<T, WebserviceError>) -> Void) {
        guard let url = URL(string: urlString) else {
            WebserviceError.message(for: .badURI)
            return
        }
        
        let request = URLRequest(url: url)
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        session.dataTask(with: request) { (data, reponse, error) in
            
            if let error = error {
                WebserviceError.message(for: .system(error))
                return
            }
            
            if let response = reponse as? HTTPURLResponse {
                if response.statusCode > 400 {
                    WebserviceError.message(for: .server(response.statusCode))
                }
            }
            
            if let decoded: T = data?.decode() {
                completion(.success(decoded))
            } else {
                WebserviceError.message(for: .decoding)
                completion(.failure(.decoding))
            }
            
        }.resume()
    }
}
