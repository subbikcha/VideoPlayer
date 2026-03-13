//
//  VideoRepositoryTests.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

final class VideoRepositoryTests: XCTestCase {

    var sut: VideosRepository!
    var mockNetworkService: MockNetworkService!

    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = VideosRepository(networkService: mockNetworkService)
    }

    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }

    func testGetVideos_Success() async throws {

        let expectedVideos = [Video.mock(id: 1), Video.mock(id: 2)]

        let mockResponse = VideoResponse(
            page: 1,
            perPage: 12,
            videos: expectedVideos,
            totalResults: 15,
            nextPage: "https://api.test.com?page=2"
        )

        mockNetworkService.result = .success(mockResponse)

        let params = PaginationParams(page: 1, perPage: 10)

        let result = try await sut.getVideos(pagination: params)

        XCTAssertEqual(result.videos.count, 2)
        XCTAssertEqual(result.videos.first?.id, 1)
        XCTAssertEqual(mockNetworkService.callCount, 1)
        XCTAssertNotNil(mockNetworkService.capturedEndpoint)
    }

    func testGetVideos_WithNilPagination() async throws {

        let mockResponse = VideoResponse.mock()

        mockNetworkService.result = .success(mockResponse)

        _ = try await sut.getVideos(pagination: nil)

        let pageQuery = mockNetworkService.capturedEndpoint?
            .queryItems
            .first(where: { $0.name == Constants.pageQueryItemKey })

        XCTAssertNil(pageQuery)
    }


    func testGetVideos_NoInternetError() async {

        mockNetworkService.result = .failure(CustomError.noInternet)

        do {
            _ = try await sut.getVideos(pagination: nil)
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? CustomError, .noInternet)
        }
    }

    func testGetVideos_ServerError() async {

        mockNetworkService.result = .failure(CustomError.serverError(500))

        do {
            _ = try await sut.getVideos(pagination: nil)
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? CustomError, .serverError(500))
        }
    }


    func testGetVideos_EmptyVideos() async throws {

        let response = VideoResponse(
            page: 1,
            perPage: 10,
            videos: [],
            totalResults: 0,
            nextPage: nil
        )

        mockNetworkService.result = .success(response)

        let result = try await sut.getVideos(pagination: nil)

        XCTAssertTrue(result.videos.isEmpty)
    }


    func testGetVideos_PaginationParametersPassedCorrectly() async throws {

        let mockResponse = VideoResponse.mock()

        mockNetworkService.result = .success(mockResponse)

        let params = PaginationParams(page: 3, perPage: 15)

        _ = try await sut.getVideos(pagination: params)

        let pageValue = mockNetworkService.capturedEndpoint?
            .queryItems
            .first(where: { $0.name == Constants.pageQueryItemKey })?.value

        let perPageValue = mockNetworkService.capturedEndpoint?
            .queryItems
            .first(where: { $0.name == Constants.perPageQueryItemKey })?.value

        XCTAssertEqual(pageValue, "3")
        XCTAssertEqual(perPageValue, "15")
    }

    func testExtractPagination_ValidURL() {

        let url = "https://api.pexels.com/v1/videos/popular?page=3&per_page=15"

        let params = sut.extractPagination(from: url)

        XCTAssertEqual(params?.page, 3)
        XCTAssertEqual(params?.perPage, 15)
    }

    func testExtractPagination_MissingParams() {

        let url = "https://api.pexels.com/v1/videos/popular"

        let params = sut.extractPagination(from: url)

        XCTAssertNil(params?.page)
        XCTAssertNil(params?.perPage)
    }

    func testExtractPagination_OnlyPage() {

        let url = "https://api.pexels.com/videos/popular?page=5"

        let params = sut.extractPagination(from: url)

        XCTAssertEqual(params?.page, 5)
        XCTAssertNil(params?.perPage)
    }

    func testExtractPagination_OnlyPerPage() {

        let url = "https://api.pexels.com/videos/popular?per_page=20"

        let params = sut.extractPagination(from: url)

        XCTAssertNil(params?.page)
        XCTAssertEqual(params?.perPage, 20)
    }

    func testExtractPagination_ReversedOrder() {

        let url = "https://api.pexels.com/videos/popular?per_page=15&page=3"

        let params = sut.extractPagination(from: url)

        XCTAssertEqual(params?.page, 3)
        XCTAssertEqual(params?.perPage, 15)
    }

    func testExtractPagination_InvalidQueryValues() {

        let url = "https://api.pexels.com/videos/popular?page=abc&per_page=xyz"

        let params = sut.extractPagination(from: url)

        XCTAssertNil(params?.page)
        XCTAssertNil(params?.perPage)
    }

    func testExtractPagination_NilURL() {

        let params = sut.extractPagination(from: nil)

        XCTAssertNil(params)
    }
}
