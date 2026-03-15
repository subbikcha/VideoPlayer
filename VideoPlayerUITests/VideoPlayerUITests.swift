//
//  VideoPlayerUITests.swift
//  VideoPlayerUITests
//
//  Created by Subbikcha K on 11/03/26.
//

import XCTest

final class VideoPlayerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = [Launch.uiTestingArgument]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Videos List

    func testVideosListAppearsWithMockData() throws {
        let navTitle = app.navigationBars[Strings.popularVideos]
        XCTAssertTrue(navTitle.waitForExistence(timeout: Timeout.standard))

        let list = app.scrollViews[AccessibilityID.videosList]
        XCTAssertTrue(list.waitForExistence(timeout: Timeout.standard))

        XCTAssertTrue(app.staticTexts[StubData.peterFowler].waitForExistence(timeout: Timeout.standard))
        XCTAssertTrue(app.staticTexts[StubData.joeyFarina].exists)
        XCTAssertTrue(app.staticTexts[StubData.ruvimMiksanskiy].exists)
    }

    func testDurationBadgesMatchStubData() throws {
        let list = app.scrollViews[AccessibilityID.videosList]
        XCTAssertTrue(list.waitForExistence(timeout: Timeout.standard))

        XCTAssertTrue(app.staticTexts[StubData.duration8s].waitForExistence(timeout: Timeout.standard))
        XCTAssertTrue(app.staticTexts[StubData.duration22s].exists)
        XCTAssertTrue(app.staticTexts[StubData.duration67s].exists)
    }

    // MARK: - Navigation

    func testTapVideoNavigatesToPlayer() throws {
        let tile = app.staticTexts[StubData.peterFowler]
        XCTAssertTrue(tile.waitForExistence(timeout: Timeout.standard))
        tile.tap()

        let toggle = app.buttons[AccessibilityID.upNextToggle]
        XCTAssertTrue(
            toggle.waitForExistence(timeout: Timeout.standard),
            "Player page should show the Up Next toggle"
        )
    }

    func testBackNavigationReturnsToList() throws {
        let tile = app.staticTexts[StubData.peterFowler]
        XCTAssertTrue(tile.waitForExistence(timeout: Timeout.standard))
        tile.tap()

        let toggle = app.buttons[AccessibilityID.upNextToggle]
        XCTAssertTrue(toggle.waitForExistence(timeout: Timeout.standard))

        app.navigationBars.buttons.element(boundBy: 0).tap()

        let navTitle = app.navigationBars[Strings.popularVideos]
        XCTAssertTrue(
            navTitle.waitForExistence(timeout: Timeout.standard),
            "Should navigate back to Popular Videos list"
        )
    }

    // MARK: - Up Next Panel

    func testUpNextToggleRevealsPanel() throws {
        let tile = app.staticTexts[StubData.peterFowler]
        XCTAssertTrue(tile.waitForExistence(timeout: Timeout.standard))
        tile.tap()

        let toggle = app.buttons[AccessibilityID.upNextToggle]
        XCTAssertTrue(toggle.waitForExistence(timeout: Timeout.standard))

        let upNextLabel = app.staticTexts[Strings.upNext]
        if !upNextLabel.exists {
            toggle.tap()
        }

        XCTAssertTrue(
            upNextLabel.waitForExistence(timeout: Timeout.short),
            "Up Next panel should be visible after toggle"
        )
    }

    func testUpNextToggleCollapsesPanel() throws {
        let tile = app.staticTexts[StubData.peterFowler]
        XCTAssertTrue(tile.waitForExistence(timeout: Timeout.standard))
        tile.tap()

        let toggle = app.buttons[AccessibilityID.upNextToggle]
        XCTAssertTrue(toggle.waitForExistence(timeout: Timeout.standard))

        let upNextLabel = app.staticTexts[Strings.upNext]

        if !upNextLabel.exists {
            toggle.tap()
        }
        XCTAssertTrue(upNextLabel.waitForExistence(timeout: Timeout.short))

        toggle.tap()

        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: upNextLabel)
        let result = XCTWaiter().wait(for: [expectation], timeout: Timeout.short)

        let panelGone = result == .completed
        XCTAssertTrue(panelGone, "Up Next panel should collapse after second toggle tap")
    }

    // MARK: - Launch Performance

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

// MARK: - Test Constants

private extension VideoPlayerUITests {

    enum Launch {
        static let uiTestingArgument = "--uitesting"
    }

    enum Timeout {
        static let standard: TimeInterval = 5
        static let short: TimeInterval = 3
    }

    enum Strings {
        static let popularVideos = "Popular Videos"
        static let upNext = "Up Next"
    }

    enum AccessibilityID {
        static let videosList = "videosList"
        static let upNextToggle = "upNextToggle"
    }

    enum StubData {
        static let peterFowler = "Peter Fowler"
        static let joeyFarina = "Joey Farina"
        static let ruvimMiksanskiy = "Ruvim Miksanskiy"

        static let duration8s = "0:08"
        static let duration22s = "0:22"
        static let duration67s = "1:07"
    }
}
