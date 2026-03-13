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

    func testGet_NoInternetError() async {

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.notConnectedToInternet)
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )
            XCTFail("Expected noInternet error")

        } catch {
            XCTAssertEqual(error as? CustomError, .noInternet)
        }
    }

    func testGet_TimeoutError() async {

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.timedOut)
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )
            XCTFail("Expected timeout error")

        } catch {
            XCTAssertEqual(error as? CustomError, .timeoutError)
        }
    }

    func testGet_GenericNetworkError() async {

        MockURLProtocol.requestHandler = { _ in
            throw URLError(.cannotFindHost)
        }

        do {
            let _: TestModel = try await sut.get(
                model: TestModel.self,
                headers: [:],
                endpoint: .mock
            )
            XCTFail("Expected network error")

        } catch {
            guard case .networkError = error as? CustomError else {
                XCTFail("Expected networkError, got \(error)")
                return
            }
        }
    }

    func testGet_SetsHTTPMethodToGET() async throws {

        let json = """
        { "id": 1 }
        """.data(using: .utf8)!

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, json)
        }

        let _: TestModel = try await sut.get(
            model: TestModel.self,
            headers: [:],
            endpoint: .mock
        )

        XCTAssertEqual(capturedRequest?.httpMethod, Constants.get)
    }

    func testGet_SetsHeaders() async throws {

        let json = """
        { "id": 1 }
        """.data(using: .utf8)!

        var capturedRequest: URLRequest?

        MockURLProtocol.requestHandler = { request in
            capturedRequest = request

            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!

            return (response, json)
        }

        let _: TestModel = try await sut.get(
            model: TestModel.self,
            headers: [Constants.contentTypeKey: Constants.contentTypeJSON],
            endpoint: .mock
        )

        XCTAssertEqual(
            capturedRequest?.value(forHTTPHeaderField: Constants.contentTypeKey),
            Constants.contentTypeJSON
        )
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
