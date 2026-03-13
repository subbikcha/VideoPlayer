//
//  VideosRepository.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation

protocol VideosRepositoryProtocol {
    func getVideos(pagination: PaginationParams?) async throws -> VideoResponse
    func extractPagination(from urlString: String?) -> PaginationParams?
}

class VideosRepository: VideosRepositoryProtocol {
    
    var networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getVideos(pagination: PaginationParams?) async throws -> VideoResponse {
        return try await networkService.get(model: VideoResponse.self,
                                            headers: Endpoint.header,
                                            endpoint: Endpoint.videos(page: pagination?.page, perPage: pagination?.perPage))
    }
    
    func extractPagination(from urlString: String?) -> PaginationParams? {
        
        guard
            let urlString,
            let url = URL(string: urlString),
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else {
            return nil
        }

        let page = components.queryItems?
            .first(where: { $0.name == Constants.pageQueryItemKey })?
            .value
            .flatMap { Int($0) }

        let perPage = components.queryItems?
            .first(where: { $0.name == Constants.perPageQueryItemKey })?
            .value
            .flatMap { Int($0) }

        return PaginationParams(page: page, perPage: perPage)
    }
    
}
