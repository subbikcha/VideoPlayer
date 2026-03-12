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
    @Published var paths: NavigationPath = NavigationPath()

    func goToPlayVideoPage(videoList: [Video], selectedIndex: Int) {
        paths.append(Path.videoPlay(videoList, selectedIndex))
    }

    func goToVideoListPage() {
        paths.append(Path.videoList)
    }

    func logout() {
        paths = NavigationPath()
        goToVideoListPage()
    }
}
