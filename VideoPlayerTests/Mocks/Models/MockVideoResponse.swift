//
//  MockVideoResponse.swift
//  MockVideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

extension Video {
    static func mock(
        id: Int = 1,
        width: Int = 100,
        height: Int = 100,
        duration: Int = 10,
        image: URL = URL(string: "https://test.com")!,
        user: User = User(id: 1, name: "Test"),
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
        nextPage: String? = "https://api.test.com?page=2"
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
        fileType: String = "video/mp4",
        width: Int? = 100,
        height: Int? = 100,
        link: URL = URL(string: "https://test.com/video.mp4")!
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
