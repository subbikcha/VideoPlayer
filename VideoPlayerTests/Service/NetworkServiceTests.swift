//
//  NetworkServiceTests.swift
//  VideoPlayerTests
//
//  Created by Subbikcha K on 13/03/26.
//

import XCTest
@testable import VideoPlayer

struct TestModel: Decodable {
    let id: Int
}

final class NetworkServiceTests: XCTestCase {

    var sut: NetworkService!

    override func setUp() {
        super.setUp()
        sut = makeNetworkService()
    }

    override func tearDown() {
        sut = nil
        MockURLProtocol.requestHandler = nil
        super.tearDown()
    }

    func testGet_Success() async throws {

        let json = """
        {
          "id": 1
        }
        """.data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, json)
        }

        let result: TestModel = try await sut.get(
            model: TestModel.self,
            headers: [:],
            endpoint: .mock
        )

        XCTAssertEqual(result.id, 1)
    }


    func testGet_ClientError() async {

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 404,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, Data())
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )
            XCTFail("Expected error")

        } catch {
            XCTAssertEqual(error as? CustomError, .clientError(404))
        }
    }

    func testGet_ServerError() async {

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, Data())
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )
            XCTFail("Expected error")

        } catch {
            XCTAssertEqual(error as? CustomError, .serverError(500))
        }
    }

    func testGet_InvalidResponse() async {

        MockURLProtocol.requestHandler = { request in

            let response = URLResponse(
                url: request.url!,
                mimeType: nil,
                expectedContentLength: 0,
                textEncodingName: nil
            )

            return (response, Data())
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )

            XCTFail("Expected error")

        } catch {
            XCTAssertEqual(error as? CustomError, .invalidResponse)
        }
    }

    func testGet_DecodingError() async {

        let invalidJSON = "{ invalid json }".data(using: .utf8)!

        MockURLProtocol.requestHandler = { request in

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, invalidJSON)
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )

            XCTFail("Expected decoding error")

        } catch {
            guard case .decodingError = error as? CustomError else {
                XCTFail("Wrong error")
                return
            }
        }
    }
}

extension NetworkServiceTests {
    func makeNetworkService() -> NetworkService {

        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]

        let session = URLSession(configuration: config)

        return NetworkService(session: session)
    }
}
