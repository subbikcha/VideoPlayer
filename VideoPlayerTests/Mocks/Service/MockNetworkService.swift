//
//  MockNetworkService.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

class MockNetworkService: NetworkServiceProtocol {

    var result: Result<VideoResponse, CustomError>?
    var capturedEndpoint: Endpoint?
    var callCount = 0

    func get<T>(model: T.Type,
                headers: Header,
                endpoint: Endpoint) async throws -> T where T : Decodable {

        callCount += 1
        capturedEndpoint = endpoint

        switch result {

        case .success(let response):
            return response as! T

        case .failure(let error):
            throw error

        case .none:
            fatalError("Mock result not set")
        }
    }
}

