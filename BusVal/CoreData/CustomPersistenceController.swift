//
//  CustomPersistenceController.swift
//  BusVal
//
//  Created by Pablo on 6/1/22.
//

import CoreData
import UIKit

class CustomPersistenceController: NSPersistentContainer {
    override class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.pespinel.BusVal"
        )
        storeURL = storeURL?.appendingPathComponent("com.pespinel.sqlite")
        return storeURL!
    }
}
