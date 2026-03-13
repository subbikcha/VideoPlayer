//
//  VideoListViewModelTests.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//


import XCTest
@testable import VideoPlayer

final class VideoListViewModelTests: XCTestCase {

    var sut: VideoListViewModel!
    var mockRepository: MockVideosRepository!

    override func setUp() {
        super.setUp()
        mockRepository = MockVideosRepository()
        sut = VideoListViewModel(repository: mockRepository)
    }

    override func tearDown() {
        sut = nil
        mockRepository = nil
        super.tearDown()
    }

    func testGetVideosInitial_Success() async {

        let videos = [Video.mock(id: 1), Video.mock(id: 2)]
        mockRepository.response = VideoResponse.mock(videos: videos)
        
        XCTAssertTrue(sut.isLoading)

        await sut.getVideosInitial()

        XCTAssertFalse(sut.isLoading)
        XCTAssertEqual(sut.videos.count, 2)
        XCTAssertFalse(sut.showInitialError)
        XCTAssertTrue(mockRepository.getVideosCalled)
    }

    func testGetVideosInitial_Failure() async {

        mockRepository.error = CustomError.noInternet

        await sut.getVideosInitial()

        XCTAssertTrue(sut.showInitialError)
        XCTAssertFalse(sut.isLoading)
        XCTAssertTrue(sut.videos.isEmpty)
    }

    func testGetVideosInitial_SetsErrorMessage() async {

        mockRepository.error = CustomError.noInternet

        await sut.getVideosInitial()

        XCTAssertFalse(sut.errorMessage.isEmpty)
    }

    func testGetVideosInitial_SetsHasMoreWhenNextPageExists() async {

        mockRepository.response = VideoResponse.mock(nextPage: "https://api.test.com?page=2")

        await sut.getVideosInitial()

        XCTAssertTrue(sut.hasMore)
    }

    func testGetVideosInitial_SetsHasMoreFalseWhenNoNextPage() async {

        mockRepository.response = VideoResponse.mock(nextPage: nil)
        mockRepository.extractedPagination = nil

        await sut.getVideosInitial()

        XCTAssertFalse(sut.hasMore)
    }

    func testGetVideosInitial_UpdatesPageAndPerPage() async {

        mockRepository.response = VideoResponse.mock()
        mockRepository.extractedPagination = PaginationParams(page: 3, perPage: 15)

        await sut.getVideosInitial()

        XCTAssertEqual(sut.page, 3)
        XCTAssertEqual(sut.perPage, 15)
    }

    func testLoadMoreIfNeeded_AppendsVideos() async {

        let initialVideos = [Video.mock(id: 1), Video.mock(id: 2)]
        mockRepository.response = VideoResponse.mock(videos: initialVideos)

        await sut.getVideosInitial()

        let moreVideos = [Video.mock(id: 3), Video.mock(id: 4)]
        mockRepository.response = VideoResponse.mock(videos: moreVideos)

        sut.hasMore = true

        await sut.loadMoreIfNeeded(index: sut.videos.count - Constants.paginationPrefetchOffset)

        XCTAssertEqual(sut.videos.count, 4)
        XCTAssertFalse(sut.showPaginationError)
    }


    func testLoadMoreIfNeeded_Failure() async {

        let initialVideos = [Video.mock(id: 1), Video.mock(id: 2)]
        mockRepository.response = VideoResponse.mock(videos: initialVideos)

        await sut.getVideosInitial()

        mockRepository.error = CustomError.serverError(500)

        sut.hasMore = true

        await sut.loadMoreIfNeeded(index: sut.videos.count - Constants.paginationPrefetchOffset)

        XCTAssertTrue(sut.showPaginationError)
    }

    func testLoadMoreIfNeeded_DoesNotTriggerForWrongIndex() async {

        let videos = [Video.mock(id: 1), Video.mock(id: 2), Video.mock(id: 3)]
        sut.videos = videos
        sut.hasMore = true

        mockRepository.getVideosCalled = false

        await sut.loadMoreIfNeeded(index: 0)

        XCTAssertFalse(mockRepository.getVideosCalled)
    }


    func testLoadMoreIfNeeded_WhenHasMoreFalse() async {

        let videos = [Video.mock(id: 1), Video.mock(id: 2)]
        sut.videos = videos
        sut.hasMore = false

        mockRepository.getVideosCalled = false

        await sut.loadMoreIfNeeded(index: sut.videos.count - Constants.paginationPrefetchOffset)

        XCTAssertFalse(mockRepository.getVideosCalled)
    }

    func testGetVideosInitial_EmptyResponse() async {

        mockRepository.response = VideoResponse.mock(videos: [])

        await sut.getVideosInitial()

        XCTAssertTrue(sut.videos.isEmpty)
        XCTAssertFalse(sut.showInitialError)
    }

    func testIsLoadingStateChanges() async {

        mockRepository.response = VideoResponse.mock()

        XCTAssertTrue(sut.isLoading)

        await sut.getVideosInitial()

        XCTAssertFalse(sut.isLoading)
    }

    func testLoadMoreIfNeeded_IsNextPageLoadingResetAfterSuccess() async {

        let initialVideos = [Video.mock(id: 1), Video.mock(id: 2)]
        mockRepository.response = VideoResponse.mock(videos: initialVideos)

        await sut.getVideosInitial()

        let moreVideos = [Video.mock(id: 3)]
        mockRepository.response = VideoResponse.mock(videos: moreVideos)
        sut.hasMore = true

        await sut.loadMoreIfNeeded(index: sut.videos.count - Constants.paginationPrefetchOffset)

        XCTAssertFalse(sut.isNextPageLoading)
    }

    func testLoadMoreIfNeeded_IsNextPageLoadingResetAfterFailure() async {

        let initialVideos = [Video.mock(id: 1), Video.mock(id: 2)]
        mockRepository.response = VideoResponse.mock(videos: initialVideos)

        await sut.getVideosInitial()

        mockRepository.error = CustomError.serverError(500)
        sut.hasMore = true

        await sut.loadMoreIfNeeded(index: sut.videos.count - Constants.paginationPrefetchOffset)

        XCTAssertFalse(sut.isNextPageLoading)
    }
}
