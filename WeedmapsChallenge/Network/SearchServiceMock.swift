//
//  SearchServiceMock.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 12/3/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import Foundation

struct SearchServiceError: Error {}

final class SearchServiceMock: SearchServiceProtocol {
    
    var fetchAutocompleteSuggestionsShouldThrow = false
    var suggestions = [String]()
    func fetchAutocompleteSuggestions(input: String, coords: LatLong, city: String) async throws -> [String] {
        if fetchAutocompleteSuggestionsShouldThrow {
            throw SearchServiceError()
        }
        return suggestions
    }
    
    var fetchBusinessesShouldThrow = false
    var businesses = [Business]()
    func fetchBusinesses(term: String, coords: LatLong, city: String) async throws -> [Business] {
        if fetchBusinessesShouldThrow {
            throw SearchServiceError()
        }
        return businesses
    }
}
