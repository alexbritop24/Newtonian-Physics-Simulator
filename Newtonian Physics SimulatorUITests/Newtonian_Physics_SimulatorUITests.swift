//
//  Newtonian_Physics_SimulatorUITests.swift
//  Newtonian Physics SimulatorUITests
//
//  Created by Alex Brito on 5/9/25.
//

import XCTest

final class Newtonian_Physics_SimulatorUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        // …
    }

    @MainActor
    func testExample() throws {
        let app = XCUIApplication()
        app.launch()
        // …
    }

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    func testTappingSpawnsABall() {
      let app = XCUIApplication()
      app.launch()

      let skView = app.otherElements["SpriteKitViewIdentifier"] // we’ll mark our SKView
      XCTAssertTrue(skView.exists)

      // Tap in the center
      skView.tap()

      // Now there should be a new node in the scene. We can verify by snapshotting child count:
      // (This is a bit of a hack—better is exposing a label or counter in your UI for testing.)
    }
    
    func testTappingSpawnsBall() {
        let app = XCUIApplication()
        app.launch()
        
        // Locate the SKView by its accessibilityIdentifier
        let skView = app.otherElements["SpriteKitViewIdentifier"]
        XCTAssertTrue(skView.exists)

        // Tap in the center of the SKView
        let center = skView.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5))
        center.tap()

        // Rough check: after tapping, assert the app is still running (didn’t crash).
        XCTAssertTrue(app.state == .runningForeground)
    }
}
