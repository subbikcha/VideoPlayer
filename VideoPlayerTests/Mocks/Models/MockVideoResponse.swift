//
//  MockVideoResponse.swift
//  MockVideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

extension Video {
    static func mock(id: Int) -> Video {
        Video(
            id: id,
            width: 100,
            height: 100,
            duration: 10,
            image: URL(string: "https://test.com")!,
            user: User(id: 1, name: "Test"),
            videoFiles: []
        )
    }
    
    static func mock(
        id: Int,
        videoFiles: [VideoFile] = []
    ) -> Video {

        Video(
            id: id,
            width: 100,
            height: 100,
            duration: 10,
            image: URL(string: "https://test.com")!,
            user: User(id: 1, name: "Test"),
            videoFiles: videoFiles
        )
    }

}

extension VideoResponse {

    static func mock(videos: [Video] = [Video.mock(id: 1)]) -> VideoResponse {

        VideoResponse(
            page: 1,
            perPage: 10,
            videos: videos,
            totalResults: videos.count,
            nextPage: "https://api.test.com?page=2"
        )
    }
}

extension VideoFile {

    static func mock(quality: String) -> VideoFile {
        VideoFile(
            id: 1,
            quality: quality,
            fileType: "video/mp4",
            width: 100,
            height: 100,
            link: URL(string: "https://test.com/video.mp4")!
        )
    }
}
