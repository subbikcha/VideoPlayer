//
//  VideoPlayerApp.swift
//  VideoPlayer
//
//  Created by Subbikcha K on 11/03/26.
//

import SwiftUI

@main
struct VideoPlayerApp: App {

    init() {
        #if DEBUG
        if ProcessInfo.processInfo.arguments.contains(Constants.launchArgumentUITesting) {
            URLProtocol.registerClass(StubURLProtocol.self)
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
