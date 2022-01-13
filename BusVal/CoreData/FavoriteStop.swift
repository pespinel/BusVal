//
//  FavoriteStop.swift
//  BusVal
//
//  Created by Pablo on 20/8/21.
//

import CoreData
import Foundation

// MARK: - FavoriteStop

@objc(FavoriteStop)
public class FavoriteStop: NSManagedObject {}

// MARK: Identifiable

extension FavoriteStop: Identifiable {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<FavoriteStop> {
        NSFetchRequest<FavoriteStop>(entityName: "FavoriteStop")
    }

    @NSManaged public var stopID: UUID
    @NSManaged public var name: String
    @NSManaged public var code: String
}
