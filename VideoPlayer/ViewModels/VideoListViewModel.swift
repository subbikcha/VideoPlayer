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
            let videosList = try await repository.getVideos(pagination: PaginationParams(page: page, perPage: perPage))
            videos.append(contentsOf: videosList.videos)
            let nextPageParams = repository.extractPagination(from: videosList.nextPage)
            self.page = nextPageParams?.page
            self.perPage = nextPageParams?.perPage
            hasMore = videosList.nextPage != nil
        } catch (let error) {
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
                let videosList = try await repository.getVideos(pagination: PaginationParams(page: page, perPage: perPage))
                videos.append(contentsOf: videosList.videos)
                let nextPageParams = repository.extractPagination(from: videosList.nextPage)
                self.page = nextPageParams?.page
                self.perPage = nextPageParams?.perPage
                hasMore = videosList.nextPage != nil
            } catch (let error) {
                showPaginationError = true
                errorMessage = error.localizedDescription
            }
        }
        
    }
}

