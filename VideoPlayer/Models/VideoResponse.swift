//
//  VideoResponse.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

struct VideoResponse: Codable {
    let page: Int
    let perPage: Int
    let videos: [Video]
    let totalResults: Int
    let nextPage: String?

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case videos
        case totalResults = "total_results"
        case nextPage = "next_page"
    }
}
