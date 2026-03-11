//
//  Endpoint.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

typealias Header = [String: Any]

struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    init(path: String, queryItems: [URLQueryItem] = []) {
        self.path = path
        self.queryItems = queryItems
    }
}

extension Endpoint {
    var url: URL {
        get throws {
            var urlComponent = URLComponents()
            urlComponent.path = path
            urlComponent.queryItems = queryItems
            urlComponent.scheme = Constants.scheme
            urlComponent.host = Constants.host
            
            guard let url = urlComponent.url else {
                throw CustomError.invalidURL
            }
            
            return url
        }
    }
    
    static var header: Header {
        return ["Content-Type": "application/json"]
    }
}

extension Endpoint {
    static func videos(page: Int?, perPage: Int?) -> Self {
        var queryItems: [URLQueryItem] = []
        
        if let page {
            queryItems.append(URLQueryItem(name: Constants.pageQueryItemKey, value: "\(page)"))
        }
        
        if let perPage {
            queryItems.append(URLQueryItem(name: Constants.perPageQueryItemKey, value: "\(perPage)"))
        }
        
        return Endpoint(path: Constants.videos, queryItems: queryItems)
    }
}
