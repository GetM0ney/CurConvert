//
//  CoreDataStack.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//


import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()

    private init() {}

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CurrencyConverterModel")
        
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data store failed: \(error)")
            } else {
                print("Loaded store: \(description)")
                print("Available entities: \(container.managedObjectModel.entities.map(\.name))")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            try? context.save()
        }
    }
}
