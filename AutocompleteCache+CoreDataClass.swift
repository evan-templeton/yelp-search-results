//
//  AutocompleteCache+CoreDataClass.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 1/7/25.
//  Copyright © 2025 Weedmaps, LLC. All rights reserved.
//
//

import Foundation
import CoreData

@objc(AutocompleteCache)
public class AutocompleteCache: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<AutocompleteCache> {
        return NSFetchRequest<AutocompleteCache>(entityName: "AutocompleteCache")
    }
    
    @NSManaged public var input: String
    @NSManaged public var city: String
    @NSManaged public var results: [String]
}

extension AutocompleteCache: Identifiable {}
