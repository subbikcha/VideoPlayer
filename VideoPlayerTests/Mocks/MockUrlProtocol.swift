//
//  MockUrlProtocol.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import Foundation

class MockURLProtocol: URLProtocol {

    static var requestHandler: ((URLRequest) throws -> (URLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {

        guard let handler = MockURLProtocol.requestHandler else {
            fatalError(MockError.handlerNotSet)
        }

        do {
            let (response, data) = try handler(request)

            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)

        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
