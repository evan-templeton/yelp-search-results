//
//  YelpSearchService.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import Foundation

final class YelpSearchService: SearchServiceProtocol {
    private static let apiKey = "Bearer SAL4YE9VCbmGRdByCMPrNoOX9sjUBQUMXcQ4UFTYEbqXhBn2f_CwAURsfCufYEfaNqPkMYtqLkWBV75EPkBjHfGY18yntKObuXCSTh9ItiA_YVRaOg7ID8lWc8pxX3Yx"
    
    private var autocompleteSuggestionsCache = [String: [String]]()
    
    func fetchAutocompleteSuggestions(input: String, coords: LatLong) async throws -> [String] {
        let request = try Self.buildAutocompleteRequest(input: input, coords: coords)
        if let cachedResults = autocompleteSuggestionsCache[input] {
            return cachedResults
        } else {
            let (data, _) = try await URLSession.shared.data(for: request)
            let autocompleteResponse = try JSONDecoder().decode(YelpAutocompleteResponse.self, from: data)
            let businessResults = autocompleteResponse.businesses.compactMap { $0.name }
            let searchTermResults = autocompleteResponse.terms.compactMap { $0["text"] }
            let results = businessResults + searchTermResults
            
            autocompleteSuggestionsCache[input] = results
            return results
        }
    }
    
    // Requires full venue name (will not autocomplete)
    func fetchBusinesses(term: String, coords: LatLong) async throws -> [Business] {
        let request = try Self.buildBusinessSearchRequest(term: term, coords: coords)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(YelpBusinessSearchResponse.self, from: data)
        return response.businesses
    }
    
    private static func buildAutocompleteRequest(input: String, coords: LatLong) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://api.yelp.com/v3/autocomplete") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [URLQueryItem(name: "text", value: input.lowercased()),
                                    URLQueryItem(name: "latitude", value: String(coords.latitude)),
                                    URLQueryItem(name: "longitude", value: String(coords.longitude)),
                                    URLQueryItem(name: "radius", value: "20000")]
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }
    
    private static func buildBusinessSearchRequest(term: String, coords: LatLong) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [URLQueryItem(name: "location", value: term),
                                    URLQueryItem(name: "term", value: term),
                                    URLQueryItem(name: "latitude", value: String(coords.latitude)),
                                    URLQueryItem(name: "longitude", value: String(coords.longitude)),
                                    URLQueryItem(name: "radius", value: "20000"),
                                    URLQueryItem(name: "limit", value: "5")]
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }
}
