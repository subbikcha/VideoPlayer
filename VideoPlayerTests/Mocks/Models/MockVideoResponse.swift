//
//  MockVideoResponse.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

enum TestDefaults {
    static let imageURL = URL(string: "https://test.com")!
    static let videoURL = URL(string: "https://test.com/video.mp4")!
    static let sdVideoURL = URL(string: "https://test.com/sd.mp4")!
    static let hdVideoURL = URL(string: "https://test.com/hd.mp4")!
    static let nextPageURL = "https://api.test.com?page=2"
    static let userName = "Test"
    static let videoMimeType = "video/mp4"
    static let sdQuality = "sd"
}

extension Video {
    static func mock(
        id: Int = 1,
        width: Int = 100,
        height: Int = 100,
        duration: Int = 10,
        image: URL = TestDefaults.imageURL,
        user: User = User(id: 1, name: TestDefaults.userName),
        videoFiles: [VideoFile] = []
    ) -> Video {
        Video(
            id: id,
            width: width,
            height: height,
            duration: duration,
            image: image,
            user: user,
            videoFiles: videoFiles
        )
    }
}

extension VideoResponse {

    static func mock(
        page: Int = 1,
        perPage: Int = 10,
        videos: [Video] = [Video.mock(id: 1)],
        totalResults: Int? = nil,
        nextPage: String? = TestDefaults.nextPageURL
    ) -> VideoResponse {
        VideoResponse(
            page: page,
            perPage: perPage,
            videos: videos,
            totalResults: totalResults ?? videos.count,
            nextPage: nextPage
        )
    }
}

extension VideoFile {

    static func mock(
        id: Int = 1,
        quality: String = Constants.preferredVideoQuality,
        fileType: String = TestDefaults.videoMimeType,
        width: Int? = 100,
        height: Int? = 100,
        link: URL = TestDefaults.videoURL
    ) -> VideoFile {
        VideoFile(
            id: id,
            quality: quality,
            fileType: fileType,
            width: width,
            height: height,
            link: link
        )
    }
}
