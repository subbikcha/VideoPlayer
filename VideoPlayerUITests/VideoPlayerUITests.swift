import XCTest

final class VideoPlayerUITests: XCTestCase {

    private var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["--uitesting"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    func testVideosListAppearsWithMockData() throws {
        let navTitle = app.navigationBars["Popular Videos"]
        XCTAssertTrue(navTitle.waitForExistence(timeout: 5))

        let list = app.scrollViews["videosList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))
        
        XCTAssertTrue(app.staticTexts["Peter Fowler"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["Joey Farina"].exists)
        XCTAssertTrue(app.staticTexts["Ruvim Miksanskiy"].exists)
    }

    func testDurationBadgesMatchStubData() throws {
        let list = app.scrollViews["videosList"]
        XCTAssertTrue(list.waitForExistence(timeout: 5))

        XCTAssertTrue(app.staticTexts["0:08"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.staticTexts["0:22"].exists)
        XCTAssertTrue(app.staticTexts["1:07"].exists)
    }

    func testTapVideoNavigatesToPlayer() throws {
        let tile = app.staticTexts["Peter Fowler"]
        XCTAssertTrue(tile.waitForExistence(timeout: 5))
        tile.tap()

        let toggle = app.buttons["upNextToggle"]
        XCTAssertTrue(
            toggle.waitForExistence(timeout: 5),
            "Player page should show the Up Next toggle"
        )
    }

    func testBackNavigationReturnsToList() throws {
        let tile = app.staticTexts["Peter Fowler"]
        XCTAssertTrue(tile.waitForExistence(timeout: 5))
        tile.tap()

        let toggle = app.buttons["upNextToggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))

        app.navigationBars.buttons.element(boundBy: 0).tap()

        let navTitle = app.navigationBars["Popular Videos"]
        XCTAssertTrue(
            navTitle.waitForExistence(timeout: 5),
            "Should navigate back to Popular Videos list"
        )
    }

    func testUpNextToggleRevealsPanel() throws {
        let tile = app.staticTexts["Peter Fowler"]
        XCTAssertTrue(tile.waitForExistence(timeout: 5))
        tile.tap()

        let toggle = app.buttons["upNextToggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))

        let upNextLabel = app.staticTexts["Up Next"]
        if !upNextLabel.exists {
            toggle.tap()
        }

        XCTAssertTrue(
            upNextLabel.waitForExistence(timeout: 3),
            "Up Next panel should be visible after toggle"
        )
    }

    func testUpNextToggleCollapsesPanel() throws {
        let tile = app.staticTexts["Peter Fowler"]
        XCTAssertTrue(tile.waitForExistence(timeout: 5))
        tile.tap()

        let toggle = app.buttons["upNextToggle"]
        XCTAssertTrue(toggle.waitForExistence(timeout: 5))

        let upNextLabel = app.staticTexts["Up Next"]

        if !upNextLabel.exists {
            toggle.tap()
        }
        XCTAssertTrue(upNextLabel.waitForExistence(timeout: 3))

        toggle.tap()

        let predicate = NSPredicate(format: "exists == false")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: upNextLabel)
        let result = XCTWaiter().wait(for: [expectation], timeout: 3)

        let panelGone = result == .completed
        XCTAssertTrue(panelGone, "Up Next panel should collapse after second toggle tap")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
