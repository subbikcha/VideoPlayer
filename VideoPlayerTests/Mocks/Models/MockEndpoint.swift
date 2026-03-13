//
//  MockEndpoint.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

extension Endpoint {
    static var mock: Endpoint {
        Endpoint(
            path: "/test",
            queryItems: []
        )
    }
}

