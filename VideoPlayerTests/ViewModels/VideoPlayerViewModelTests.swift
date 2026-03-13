//
//  VideoPlayerViewModelTests.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

final class VideoPlayerViewModelTests: XCTestCase {

    var sut: VideoPlayerViewModel!

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testInit_setsInitialValues() {
        let videos = [Video.mock(id: 1), Video.mock(id: 2)]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 1)

        XCTAssertEqual(sut.videos.count, 2)
        XCTAssertEqual(sut.currentIndex, 1)
        XCTAssertFalse(sut.showUpNext)
        XCTAssertFalse(sut.isVideoLoading)
        XCTAssertFalse(sut.videoError)
    }

    func testCurrentVideo_returnsCorrectVideo() {
        let videos = [Video.mock(id: 10), Video.mock(id: 20)]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 1)

        XCTAssertEqual(sut.currentVideo.id, 20)
    }

    func testToggleShowUp_togglesValue() {
        sut = VideoPlayerViewModel(videos: [Video.mock(id: 1)], selectedIndex: 0)

        XCTAssertFalse(sut.showUpNext)

        sut.toggleShowUp()

        XCTAssertTrue(sut.showUpNext)

        sut.toggleShowUp()

        XCTAssertFalse(sut.showUpNext)
    }

    func testNextVideos_returnsRemainingVideos() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2),
            Video.mock(id: 3)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 1)

        let result = sut.nextVideos

        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result.first?.id, 2)
    }

    func testNextVideos_whenLastVideo_returnsSingleVideo() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 1)

        let result = sut.nextVideos

        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.id, 2)
    }

    func testPlayNextVideo_movesToNextIndex() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 0)

        sut.playNextVideo()

        XCTAssertEqual(sut.currentIndex, 1)
    }

    func testPlayNextVideo_whenLastVideo_doesNotChangeIndex() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 1)

        sut.playNextVideo()

        XCTAssertEqual(sut.currentIndex, 1)
    }

    func testSelectVideo_setsIndex() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2),
            Video.mock(id: 3)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 0)

        sut.selectVideo(at: 2)

        XCTAssertEqual(sut.currentIndex, 2)
    }

    func testGetVideoUrl_returnsHDVideo() {

        let videoFile = VideoFile.mock(quality: "hd")

        let video = Video.mock(
            id: 1,
            videoFiles: [videoFile]
        )

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertEqual(url, videoFile.link)
    }

    func testGetVideoUrl_fallbackToFirstVideo() {

        let videoFile = VideoFile.mock(quality: "sd")

        let video = Video.mock(
            id: 1,
            videoFiles: [videoFile]
        )

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertEqual(url, videoFile.link)
    }

    func testGetVideoUrl_whenNoVideos_returnsNil() {

        let video = Video.mock(id: 1, videoFiles: [])

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertNil(url)
    }
}
