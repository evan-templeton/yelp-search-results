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
    
    /// Find your Yelp API Key here https://www.yelp.com/developers/v3/manage_app
    private static let apiKey = "Bearer [YELP SEARCH API KEY]"
    
    private let persistentContainer: NSPersistentContainer
    
    init() {
        persistentContainer = NSPersistentContainer(name: "YelpCache")
        persistentContainer.loadPersistentStores { _, error in
            if let error {
                debugPrint("Failed to load Core Data stack: \(error)")
            }
        }
    }
    
    // MARK: - Autocomplete
    func fetchAutocompleteSuggestions(input: String, coords: LatLong, city: String) async throws -> [String] {
        if let cachedResults = fetchCachedSuggestions(for: input, city: city) {
            return cachedResults
        }
        
        let request = try Self.buildAutocompleteRequest(input: input, coords: coords)
        let (data, _) = try await URLSession.shared.data(for: request)
        let autocompleteResponse = try JSONDecoder().decode(YelpAutocompleteResponse.self, from: data)
        let businessResults = autocompleteResponse.businesses.compactMap { $0.name }
        let searchTermResults = autocompleteResponse.terms.compactMap { $0["text"] }
        let results = businessResults + searchTermResults
        
        saveSuggestionsToCache(input: input, city: city, results: results)
        
        return results
    }
    
    private func fetchCachedSuggestions(for input: String, city: String) -> [String]? {
        let context = persistentContainer.viewContext
        let request = AutocompleteCache.fetchRequest()
        request.predicate = NSPredicate(format: "input == [c] %@ AND city == [c] %@", input, city)
        
        if let cachedEntry = try? context.fetch(request).first {
            return cachedEntry.results
        }
        
        return nil
    }
    
    private func saveSuggestionsToCache(input: String, city: String, results: [String]) {
        let context = persistentContainer.viewContext
        let cacheEntry = AutocompleteCache(context: context)
        cacheEntry.input = input
        cacheEntry.city = city
        cacheEntry.results = results
        
        do {
            try context.save()
        } catch {
            debugPrint("Failed to save autocomplete suggestions to cache: \(error)")
        }
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
    
    // MARK: - Fetch Businesses
    // Requires full venue name (will not autocomplete)
    func fetchBusinesses(term: String, coords: LatLong, city: String) async throws -> [Business] {
        if let cachedBusinesses = fetchCachedBusinesses(for: term, city: city) {
            return cachedBusinesses
        }
        
        let request = try Self.buildBusinessSearchRequest(term: term, coords: coords)
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try JSONDecoder().decode(YelpBusinessSearchResponse.self, from: data)
        let businesses = response.businesses
        
        saveBusinessesToCache(input: term, city: city, results: businesses)
        
        return businesses
    }
    
    private func fetchCachedBusinesses(for input: String, city: String) -> [Business]? {
        let context = persistentContainer.viewContext
        let request = BusinessCache.fetchRequest()
        request.predicate = NSPredicate(format: "input == [c] %@ AND city == [c] %@", input, city)
        
        if let cachedEntry = try? context.fetch(request).first {
            return cachedEntry.results
        }
        
        return nil
    }
    
    private func saveBusinessesToCache(input: String, city: String, results: [Business]) {
        let context = persistentContainer.viewContext
        let cacheEntry = BusinessCache(context: context)
        cacheEntry.input = input
        cacheEntry.city = city
        cacheEntry.results = results
        
        do {
            try context.save()
        } catch {
            debugPrint("Failed to save businesses to cache: \(error)")
        }
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
