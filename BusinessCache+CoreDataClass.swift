//
//  BusinessCache+CoreDataClass.swift
//  WeedmapsChallenge
//
//  Created by Evan Templeton on 1/9/25.
//  Copyright © 2025 Weedmaps, LLC. All rights reserved.
//
//

import Foundation
import CoreData

@objc(BusinessCache)
public class BusinessCache: NSManagedObject {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BusinessCache> {
        return NSFetchRequest<BusinessCache>(entityName: "BusinessCache")
    }
    
    @NSManaged public var city: String
    @NSManaged public var input: String
    @NSManaged public var results: [Business]
}

extension BusinessCache: Identifiable {}
