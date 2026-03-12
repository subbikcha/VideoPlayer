//
//  Video.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

struct Video: Codable, Identifiable, Hashable {
    let id: Int
    let width: Int
    let height: Int
    let duration: Int
    let image: URL
    let user: User
    let videoFiles: [VideoFile]

    enum CodingKeys: String, CodingKey {
        case id
        case width
        case height
        case duration
        case image
        case user
        case videoFiles = "video_files"
    }
}

struct User: Codable, Hashable {
    let id: Int
    let name: String
}

struct VideoFile: Codable, Hashable {
    let id: Int
    let quality: String
    let fileType: String
    let width: Int?
    let height: Int?
    let link: URL

    enum CodingKeys: String, CodingKey {
        case id
        case quality
        case fileType = "file_type"
        case width
        case height
        case link
    }
}
