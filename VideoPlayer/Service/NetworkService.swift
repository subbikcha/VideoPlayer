//
//  NetworkService.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func get<T: Decodable>(model: T.Type, headers: Header, endpoint: Endpoint) async throws -> T
}

class NetworkService: NetworkServiceProtocol {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func get<T: Decodable>(
        model: T.Type,
        headers: Header,
        endpoint: Endpoint
    ) async throws -> T {
        
        let request = try buildRequest(headers: headers, endpoint: endpoint)
        
        let (data, response) = try await performRequest(request)
        
        try validateResponse(response)
        
        return try decode(data)
    }
    
}

extension NetworkService {
    private func buildRequest(headers: Header, endpoint: Endpoint) throws -> URLRequest {
        
        var request = try URLRequest(url: endpoint.url)
        
        headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        request.httpMethod = Constants.get
        
        return request
    }
    
    private func performRequest(_ request: URLRequest) async throws -> (Data, URLResponse) {
        
        do {
            return try await session.data(for: request)
        } catch let error as URLError {
            if error.code == .notConnectedToInternet {
                throw CustomError.noInternet
            }
            if error.code == .timedOut {
                throw CustomError.timeoutError
            }
            throw CustomError.networkError(error.localizedDescription)
        } catch {
            throw CustomError.networkError(error.localizedDescription)
        }
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw CustomError.invalidResponse
        }
        
        switch httpResponse.statusCode {
            
        case Constants.httpSuccessRange:
            return
            
        case Constants.httpClientErrorRange:
            throw CustomError.clientError(httpResponse.statusCode)
            
        case Constants.httpServerErrorRange:
            throw CustomError.serverError(httpResponse.statusCode)
            
        default:
            throw CustomError.invalidResponse
        }
    }
    
    private func decode<T: Decodable>(_ data: Data) throws -> T {
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw CustomError.decodingError(error)
        }
    }
}
