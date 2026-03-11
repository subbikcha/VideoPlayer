//
//  Error.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

enum CustomError: Error {
    case noInternet
    case timeoutError
    case invalidResponse
    case clientError(Int)
    case serverError(Int)
    case decodingError(Error)
    case networkError(String)
    case invalidURL
}
