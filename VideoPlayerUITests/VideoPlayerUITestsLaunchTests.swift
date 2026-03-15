//
//  VideoPlayerUITestsLaunchTests.swift
//  VideoPlayerUITests
//
//  Created by Subbikcha K on 11/03/26.
//

import XCTest

final class VideoPlayerUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = AttachmentName.launchScreen
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}

private extension VideoPlayerUITestsLaunchTests {
    enum AttachmentName {
        static let launchScreen = "Launch Screen"
    }
}
