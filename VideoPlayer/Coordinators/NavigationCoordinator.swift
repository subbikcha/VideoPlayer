//
//  NavigationCoordinators.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import Foundation
import SwiftUI

enum Path: Hashable {
    case videoPlay([Video], Int)
    case videoList
}

class NavigationCoordinator: ObservableObject {
    @Published var navigationPath: NavigationPath = NavigationPath()

    func goToPlayVideoPage(videoList: [Video], selectedIndex: Int) {
        navigationPath.append(Path.videoPlay(videoList, selectedIndex))
    }

    func goToVideoListPage() {
        navigationPath.append(Path.videoList)
    }

    func logout() {
        navigationPath = NavigationPath()
        goToVideoListPage()
    }
}
