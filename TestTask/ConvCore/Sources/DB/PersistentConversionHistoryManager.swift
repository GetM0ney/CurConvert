//
//  PersistentConversionHistoryManager.swift
//  CurrencyConverter
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//

import Combine
import CoreData


public final class PersistentConversionHistoryManager: IConversionHistoryManager {
    public var historyPublisher: AnyPublisher<[ConversionHistoryItem], Never> {
        $history.eraseToAnyPublisher()
    }
    
    @Published public var history: [ConversionHistoryItem] = []

    private var context: NSManagedObjectContext {
        CoreDataStack.shared.context
    }

    public init() {
        fetchHistory()
    }

    public func add(_ item: ConversionHistoryItem) {
//        let entity = NSEntityDescription.entity(forEntityName: "MyClass", in: context)!
        let entity = ConversionHistoryEntity(context: context)
        entity.date = item.date
        entity.from = item.from.rawValue
        entity.to = item.to.rawValue
        entity.amount = item.amount
        entity.result = item.result
        entity.rate = item.rate

        do {
            try context.save()
            history.insert(item, at: 0)
        } catch {
            print("Failed to save: \(error)")
        }
    }

    private func fetchHistory() {
        let request: NSFetchRequest<ConversionHistoryEntity> = ConversionHistoryEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]

        do {
            let result = try context.fetch(request)
            self.history = result.map {
                ConversionHistoryItem(
                    date: $0.date ?? Date(),
                    from: Currency(rawValue: $0.from ?? "") ?? .usd,
                    to: Currency(rawValue: $0.to ?? "") ?? .eur,
                    amount: $0.amount,
                    result: $0.result,
                    rate: $0.rate
                )
            }
        } catch {
            print("Failed to fetch history: \(error)")
        }
    }
}
