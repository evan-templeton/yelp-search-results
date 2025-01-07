//
//  YelpSearchService.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 11/29/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import Foundation
import CoreData

final class YelpSearchService: SearchServiceProtocol {
    private static let apiKey = "Bearer SAL4YE9VCbmGRdByCMPrNoOX9sjUBQUMXcQ4UFTYEbqXhBn2f_CwAURsfCufYEfaNqPkMYtqLkWBV75EPkBjHfGY18yntKObuXCSTh9ItiA_YVRaOg7ID8lWc8pxX3Yx"
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "YelpCache")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                print("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    // MARK: - Autocomplete
    func fetchAutocompleteSuggestions(input: String, location: Location) async throws -> [String] {
        if let cachedResults = fetchCachedSuggestions(for: input, city: location.city) {
            return cachedResults
        }
        
        let request = try Self.buildAutocompleteRequest(input: input, location: location)
        let (data, _) = try await URLSession.shared.data(for: request)
        let autocompleteResponse = try JSONDecoder().decode(YelpAutocompleteResponse.self, from: data)
        let businessResults = autocompleteResponse.businesses.compactMap { $0.name }
        let searchTermResults = autocompleteResponse.terms.compactMap { $0["text"] }
        let results = businessResults + searchTermResults
        
        saveSuggestionsToCache(input: input, city: location.city, results: results)
        
        return results
    }
    
    private func fetchCachedSuggestions(for input: String, city: String) -> [String]? {
        let context = persistentContainer.viewContext
        let request = AutocompleteCache.fetchRequest()
        request.predicate = NSPredicate(format: "input == %@ AND city == %@", input, city)
        
        if let cachedEntry = try? context.fetch(request).first {
            return cachedEntry.results
        }
        
        return nil
    }
    
    private func saveSuggestionsToCache(input: String, city: String, results: [String]) {
        let context = persistentContainer.viewContext
        let cacheEntry = AutocompleteCache(context: context)
        cacheEntry.input = input
        cacheEntry.results = results
        
        do {
            try context.save()
        } catch {
            print("Failed to save autocomplete suggestions to cache: \(error)")
        }
    }
    
    private static func buildAutocompleteRequest(input: String, location: Location) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://api.yelp.com/v3/autocomplete") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [URLQueryItem(name: "text", value: input.lowercased()),
                                    URLQueryItem(name: "latitude", value: String(location.latitude)),
                                    URLQueryItem(name: "longitude", value: String(location.longitude)),
                                    URLQueryItem(name: "radius", value: "20000")]
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }
    
    // MARK: - Fetch Businesses
    // Requires full venue name (will not autocomplete)
    func fetchBusinesses(term: String, location: Location) async throws -> [Business] {
        let request = try Self.buildBusinessSearchRequest(term: term, location: location)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(YelpBusinessSearchResponse.self, from: data)
        return response.businesses
    }
    
    private static func buildBusinessSearchRequest(term: String, location: Location) throws -> URLRequest {
        guard var urlComponents = URLComponents(string: "https://api.yelp.com/v3/businesses/search") else {
            throw URLError(.badURL)
        }
        urlComponents.queryItems = [URLQueryItem(name: "location", value: term),
                                    URLQueryItem(name: "term", value: term),
                                    URLQueryItem(name: "latitude", value: String(location.latitude)),
                                    URLQueryItem(name: "longitude", value: String(location.longitude)),
                                    URLQueryItem(name: "radius", value: "20000"),
                                    URLQueryItem(name: "limit", value: "5")]
        guard let url = urlComponents.url else { throw URLError(.badURL) }
        var request = URLRequest(url: url)
        request.setValue(apiKey, forHTTPHeaderField: "Authorization")
        return request
    }
}
