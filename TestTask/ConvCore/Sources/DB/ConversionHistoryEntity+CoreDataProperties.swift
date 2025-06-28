//
//  ConversionHistoryEntity+CoreDataProperties.swift
//  
//
//  Created by Uladzimir Lishanenka on 27.06.2025.
//
//

import Foundation
import CoreData


extension ConversionHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ConversionHistoryEntity> {
        return NSFetchRequest<ConversionHistoryEntity>(entityName: "ConversionHistoryEntity")
    }

    @NSManaged public var date: Date?
    @NSManaged public var from: String?
    @NSManaged public var to: String?
    @NSManaged public var amount: Double
    @NSManaged public var rate: Double
    @NSManaged public var result: Double

}
