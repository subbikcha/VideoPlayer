//
//  Constanst.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

struct Constants {
    static let host = "api.pexels.com"
    static let scheme = "https"
}

//Endpoints
extension Constants {
    static let videos = "/videos/popular"
    static let pageQueryItemKey = "page"
    static let perPageQueryItemKey = "per_page"
}

//Http methods
extension Constants {
    static let get = "GET"
}
