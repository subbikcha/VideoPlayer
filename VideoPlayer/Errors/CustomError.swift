//
//  Error.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

enum CustomError: Error, Equatable {

    static func == (lhs: CustomError, rhs: CustomError) -> Bool {
        switch (lhs, rhs) {

        case (.noInternet, .noInternet):
            return true

        case (.timeoutError, .timeoutError):
            return true

        case (.invalidResponse, .invalidResponse):
            return true

        case (.invalidURL, .invalidURL):
            return true

        case (.clientError(let lhsCode), .clientError(let rhsCode)):
            return lhsCode == rhsCode

        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode

        case (.networkError(let lhsMsg), .networkError(let rhsMsg)):
            return lhsMsg == rhsMsg

        case (.decodingError, .decodingError):
            return true

        default:
            return false
        }
    }

    case noInternet
    case timeoutError
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
    case decodingError(Error)
    case networkError(String)
    case invalidURL
}
