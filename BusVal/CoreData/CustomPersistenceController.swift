//
//  CustomPersistenceController.swift
//  BusVal
//
//  Created by Pablo on 6/1/22.
//

import CoreData
import UIKit

class CustomPersistenceController: NSPersistentCloudKitContainer {
    override class func defaultDirectoryURL() -> URL {
        var storeURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: "group.com.busval"
        )
        storeURL = storeURL?.appendingPathComponent("com.pespinel.sqlite")
        return storeURL!
    }
}
