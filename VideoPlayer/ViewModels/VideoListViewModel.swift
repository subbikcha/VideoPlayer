//
//  VideoListViewModel.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation


class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var showInitialError = false
    @Published var showPaginationError = false
    @Published var isLoading: Bool = true
    var hasMore: Bool = false
    @Published var isNextPageLoading = false
    var errorMessage: String = ""
    var page: Int?
    var perPage: Int?
    
    
    let repository: VideosRepositoryProtocol
    
    init(repository: VideosRepositoryProtocol = VideosRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func getVideosInitial() async {
        isLoading = true
        defer {
            isLoading = false
        }
        do {
            try await fetchAndAppendVideos()
        } catch {
            showInitialError = true
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func loadMoreIfNeeded(index: Int) async {
        if index == videos.count - Constants.paginationPrefetchOffset {
            guard hasMore else { return }
            isNextPageLoading = true
            defer {
                isNextPageLoading = false
            }
            do {
                try await fetchAndAppendVideos()
            } catch {
                showPaginationError = true
                errorMessage = error.localizedDescription
            }
        }
    }

    @MainActor
    private func fetchAndAppendVideos() async throws {
        let response = try await repository.getVideos(
            pagination: PaginationParams(page: page, perPage: perPage)
        )
        videos.append(contentsOf: response.videos)
        let nextPageParams = repository.extractPagination(from: response.nextPage)
        page = nextPageParams?.page
        perPage = nextPageParams?.perPage
        hasMore = response.nextPage != nil
    }
}
