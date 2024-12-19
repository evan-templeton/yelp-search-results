//
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import XCTest

final class NearbyViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testSearchInputPlaceholder() {
        let searchField = app.textFields["searchInputField"]
        XCTAssertTrue(searchField.exists, "Search input placeholder should have initial value.")
    }
    
    func testInitialEmptyState() {
        let title = app.staticTexts["Yelp Business Search"]
        XCTAssertTrue(title.exists, "Content unavailable message should be visible initially.")
        
        let description = app.staticTexts["Use the search bar above to find nearby businesses"]
        XCTAssertTrue(description.exists, "Content unavailable description should be visible initially.")
    }
    
    func testLocationRequestButton() {
        let locationButton = app.buttons["Current Location"]
        XCTAssertTrue(locationButton.exists, "Current location button should exist.")
        XCTAssertTrue(locationButton.isHittable, "Current location button should be hittable.")
    }
    
    func testBusinessSelectionShowsAlert() {
        let searchField = app.textFields["searchInputField"]
        searchField.tap()
        searchField.typeText("Coffee")
        
        let firstSuggestion = app.buttons["suggestion"].firstMatch
        XCTAssertTrue(firstSuggestion.waitForExistence(timeout: 2))
        firstSuggestion.tap()
        
        let firstBusiness = app.buttons["business"].firstMatch
        XCTAssertTrue(firstBusiness.waitForExistence(timeout: 2))
        firstBusiness.tap()
        
        let alert = app.alerts.firstMatch
        XCTAssertTrue(alert.exists, "Business alert should appear when tapping a business.")
        
        let openInSafariButton = alert.buttons["Open in Safari"]
        XCTAssertTrue(openInSafariButton.exists, "Alert should have 'Open in Safari' button.")
        
        let openInWebViewButton = alert.buttons["Open in Webview"]
        XCTAssertTrue(openInWebViewButton.exists, "Alert should have 'Open in Webview' button.")
        
        let cancelButton = alert.buttons["Cancel"]
        XCTAssertTrue(cancelButton.exists, "Alert should have a 'Cancel' button.")
    }
}
