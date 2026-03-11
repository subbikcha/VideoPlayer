//
//  VideoListViewModel.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation


class VideoListViewModel: ObservableObject {
    @Published var videos: [Video] = []
    @Published var showError: Bool = false
    @Published var loading: Bool = true
    @Published var hasMore: Bool = true
    var errorMessage: String = ""
    var page: Int?
    var perPage: Int?
    
    
    let repository: VideosRepositoryProtocol
    
    init(repository: VideosRepositoryProtocol = VideosRepository()) {
        self.repository = repository
    }
    
    @MainActor
    func getVideosInitial() async {
        loading = true
        defer {
            loading = false
        }
        do {
            let videosList = try await repository.getVideos(pagination: PaginationParams(page: page, perPage: perPage))
            videos.append(contentsOf: videosList.videos)
            let nextPageParams = repository.extractPagination(from: videosList.nextPage)
            self.page = nextPageParams?.page
            self.perPage = nextPageParams?.perPage
            hasMore = videosList.nextPage != nil
        } catch (let error) {
            showError = true
            errorMessage = error.localizedDescription
        }
    }
    
    @MainActor
    func loadMoreIfNeeded() async {
        guard hasMore else { return }
        hasMore = false
        do {
            let videosList = try await repository.getVideos(pagination: PaginationParams(page: page, perPage: perPage))
            videos.append(contentsOf: videosList.videos)
            let nextPageParams = repository.extractPagination(from: videosList.nextPage)
            self.page = nextPageParams?.page
            self.perPage = nextPageParams?.perPage
            hasMore = videosList.nextPage != nil
        } catch (let error) {
            showError = true
            errorMessage = error.localizedDescription
        }
        
    }
    
}
