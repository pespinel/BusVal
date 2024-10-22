//
//  PersistenceController.swift
//  BusVal
//
//  Created by Pablo on 5/1/22.
//

import CoreData

struct PersistenceController {
    // MARK: Lifecycle

    init(inMemory: Bool = false) {
        container = CustomPersistenceController(name: "BusVal")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    // MARK: Internal

    static let shared = Self()

    static var preview: PersistenceController = {
        let result = Self(inMemory: true)
        let viewContext = result.container.viewContext
        let stop = FavoriteStop()
        stop.code = "698"
        stop.name = "Calle Gondomar 12 esquina Santa Clara"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: CustomPersistenceController
}
