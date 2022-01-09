//
//  PersistenceController.swift
//  BusVal
//
//  Created by Pablo on 5/1/22.
//

import CoreData

// swiftlint:disable unused_closure_parameter
struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
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

    init(inMemory: Bool = false) {
        container = CustomPersistenceController(name: "BusVal")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
