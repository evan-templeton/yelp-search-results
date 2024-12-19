//
//  YelpModels.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 12/3/24.
//  Copyright © 2024 Weedmaps, LLC. All rights reserved.
//

import Foundation

/// Response object from Yelp's autocomplete endpoint
///
/// https://docs.developer.yelp.com/reference/v3_autocomplete
struct YelpAutocompleteResponse: Codable {
    let businesses: [YelpAutocompleteBusinessResponse]
    let terms: [[String: String]]
}

struct YelpAutocompleteBusinessResponse: Codable {
    let id: String
    let name: String
}

struct YelpBusinessSearchResponse: Codable {
    let businesses: [Business]
}

/// Response object from Yelp's business search endpoint
///
/// https://docs.developer.yelp.com/reference/v3_business_search
struct Business: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let rating: Double
    let imageURL: URL
    let url: URL
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, url
        case imageURL = "image_url"
    }
}
