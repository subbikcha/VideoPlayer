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

extension Constants {
    static let videos = "/videos/popular"
    static let pageQueryItemKey = "page"
    static let perPageQueryItemKey = "per_page"
}

extension Constants {
    static let get = "GET"
    static let contentTypeKey = "Content-Type"
    static let contentTypeJSON = "application/json"
}

extension Constants {
    static let preferredVideoQuality = "hd"
    static let paginationPrefetchOffset = 2
}

extension Constants {
    static let httpSuccessRange = 200..<300
    static let httpClientErrorRange = 400..<500
    static let httpServerErrorRange = 500..<600
}
