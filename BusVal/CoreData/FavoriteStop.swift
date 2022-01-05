//
//  FavoriteStop.swift
//  BusVal
//
//  Created by Pablo on 20/8/21.
//

import CoreData
import Foundation

@objc(FavoriteStop)
public class FavoriteStop: NSManagedObject {}

extension FavoriteStop: Identifiable {
    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<FavoriteStop> {
        return NSFetchRequest<FavoriteStop>(entityName: "FavoriteStop")
    }

    @NSManaged public var id: UUID
    @NSManaged public var name: String
    @NSManaged public var code: String
}
