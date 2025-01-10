//
//  SearchServiceProtocol.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 12/3/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import Foundation

protocol SearchServiceProtocol {
    func fetchAutocompleteSuggestions(input: String, coords: LatLong, city: String) async throws -> [String]
    func fetchBusinesses(term: String, coords: LatLong, city: String) async throws -> [Business]
}
