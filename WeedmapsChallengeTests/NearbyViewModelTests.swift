//
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import XCTest
@testable import WeedmapsChallenge

@MainActor
final class NearbyViewModelTests: XCTestCase {

    private var searchService: SearchServiceMock!
    private var viewModel: NearbyViewModel!
    
    override func setUp() {
        searchService = SearchServiceMock()
        viewModel = NearbyViewModel(searchService: searchService)
    }
    
    func testGetAutocompleteSuggestions_handlePopulatedResponse() async {
        searchService.suggestions = ["Pizza Near Me", "Picasso", "Pizza Hut"]
        XCTAssertTrue(viewModel.suggestions.isEmpty)
        await viewModel.getAutocompleteSuggestions(input: "Test")
        XCTAssertEqual(viewModel.suggestions, searchService.suggestions)
    }
    
    func testGetAutocompleteSuggestions_handleEmptyResponse() async {
        searchService.suggestions = []
        await viewModel.getAutocompleteSuggestions(input: "Test")
        XCTAssertTrue(viewModel.suggestions.isEmpty)
    }

    func testGetAutocompleteSuggestions_handleError() async {
        searchService.fetchAutocompleteSuggestionsShouldThrow = true
        await viewModel.getAutocompleteSuggestions(input: "Test")
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
    func testGetBusinesses_handlePopulatedResponse() async {
        searchService.businesses = [.mock]
        XCTAssertTrue(viewModel.businesses.isEmpty)
        await viewModel.getBusinesses(input: "Test")
        XCTAssertEqual(viewModel.businesses, searchService.businesses)
    }
    
    func testGetBusinesses_handleEmptyResponse() async {
        searchService.businesses = []
        await viewModel.getBusinesses(input: "Test")
        XCTAssertTrue(viewModel.businesses.isEmpty)
    }
    
    func testGetBusinesses_handleError() async {
        searchService.fetchBusinessesShouldThrow = true
        await viewModel.getBusinesses(input: "Test")
        XCTAssertNotNil(viewModel.errorMessage)
    }
    
}

private extension Business {
    static var mock: Business {
        Business(id: "id", name: "name", rating: 4.0, imageURL: .applicationDirectory, url: .cachesDirectory)
    }
}
