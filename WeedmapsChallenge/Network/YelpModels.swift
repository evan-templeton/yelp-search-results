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
public class Business: NSObject, Codable, Identifiable, NSSecureCoding {
    public static var supportsSecureCoding = true
    
    public func encode(with coder: NSCoder) {
        coder.encode(id, forKey: "id")
        coder.encode(name, forKey: "name")
        coder.encode(rating, forKey: "rating")
        coder.encode(imageURL, forKey: "image_url")
        coder.encode(url, forKey: "url")
    }
    
    public required init?(coder: NSCoder) {
        let rating = coder.decodeDouble(forKey: "rating")
        if let id = coder.decodeObject(forKey: "id") as? String,
           let name = coder.decodeObject(forKey: "name") as? String,
           let imageURL = coder.decodeObject(forKey: "image_url") as? URL,
           let url = coder.decodeObject(forKey: "url") as? URL {
            self.id = id
            self.name = name
            self.rating = rating
            self.imageURL = imageURL
            self.url = url
        } else {
            return nil
        }
    }
    
    public let id: String
    let name: String
    let rating: Double
    let imageURL: URL
    let url: URL
    
    init(id: String, name: String, rating: Double, imageURL: URL, url: URL) {
        self.id = id
        self.name = name
        self.rating = rating
        self.imageURL = imageURL
        self.url = url
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, rating, url
        case imageURL = "image_url"
    }
}
