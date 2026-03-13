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

    func testToggleUpNext_togglesValue() {
        sut = VideoPlayerViewModel(videos: [Video.mock(id: 1)], selectedIndex: 0)

        XCTAssertFalse(sut.showUpNext)

        sut.toggleUpNext()

        XCTAssertTrue(sut.showUpNext)

        sut.toggleUpNext()

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

    func testNextVideos_whenFirstVideo_returnsAll() {
        let videos = [
            Video.mock(id: 1),
            Video.mock(id: 2),
            Video.mock(id: 3)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 0)

        let result = sut.nextVideos

        XCTAssertEqual(result.count, 3)
        XCTAssertEqual(result.first?.id, 1)
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

        let videoFile = VideoFile.mock(quality: Constants.preferredVideoQuality)

        let video = Video.mock(
            id: 1,
            videoFiles: [videoFile]
        )

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertEqual(url, videoFile.link)
    }

    func testGetVideoUrl_prefersHDOverSD() {

        let sdFile = VideoFile.mock(id: 1, quality: "sd", link: URL(string: "https://test.com/sd.mp4")!)
        let hdFile = VideoFile.mock(id: 2, quality: Constants.preferredVideoQuality, link: URL(string: "https://test.com/hd.mp4")!)

        let video = Video.mock(id: 1, videoFiles: [sdFile, hdFile])

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertEqual(url, hdFile.link)
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

    func testGetVideoUrl_whenNoVideoFiles_returnsNil() {

        let video = Video.mock(id: 1, videoFiles: [])

        sut = VideoPlayerViewModel(videos: [video], selectedIndex: 0)

        let url = sut.getVideoUrl()

        XCTAssertNil(url)
    }

    func testCurrentVideo_afterPlayNext_returnsCorrectVideo() {
        let videos = [
            Video.mock(id: 10),
            Video.mock(id: 20),
            Video.mock(id: 30)
        ]

        sut = VideoPlayerViewModel(videos: videos, selectedIndex: 0)

        XCTAssertEqual(sut.currentVideo.id, 10)

        sut.playNextVideo()

        XCTAssertEqual(sut.currentVideo.id, 20)
    }
}
