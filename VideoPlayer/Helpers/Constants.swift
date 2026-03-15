//
//  Constants.swift
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
    static let httpStatusOK = 200
    static let httpSuccessRange = 200..<300
    static let httpClientErrorRange = 400..<500
    static let httpServerErrorRange = 500..<600
}

extension Constants {
    static let secondsPerMinute = 60
    static let durationFormat = "%d:%02d"
    static let launchArgumentUITesting = "--uitesting"
}

extension Constants {
    enum Strings {
        static let popularVideos = "Popular Videos"
        static let retry = "Retry"
        static let failedToLoadMore = "Failed to load more videos"
        static let failedToPlayVideo = "Failed to play video"
        static let upNext = "Up Next"
    }
}

extension Constants {
    enum SFSymbol {
        static let wifiSlash = "wifi.slash"
        static let exclamationTriangleFill = "exclamationmark.triangle.fill"
        static let chevronDownCircleFill = "chevron.down.circle.fill"
        static let chevronUpCircleFill = "chevron.up.circle.fill"
    }
}

extension Constants {
    enum AccessibilityID {
        static let videosList = "videosList"
        static let loadingSkeleton = "loadingSkeleton"
        static let upNextPanel = "upNextPanel"
        static let upNextToggle = "upNextToggle"
        static let retryButton = "retryButton"
        static let errorScreen = "errorScreen"
        static let videoTilePrefix = "videoTile_"
    }
}
