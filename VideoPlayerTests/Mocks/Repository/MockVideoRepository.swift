//
//  MockVideoRepository.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

class MockVideosRepository: VideosRepositoryProtocol {

    var response: VideoResponse?
    var error: Error?
    var getVideosCalled = false
    var extractedPagination: PaginationParams? = PaginationParams(page: 2, perPage: 10)

    func getVideos(pagination: PaginationParams?) async throws -> VideoResponse {

        getVideosCalled = true

        if let error {
            throw error
        }

        return response ?? VideoResponse.mock()
    }

    func extractPagination(from url: String?) -> PaginationParams? {
        return extractedPagination
    }
}
