//
//  CompanyCD+CoreDataProperties.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//
//

import Foundation
import CoreData


extension CompanyCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompanyCD> {
        return NSFetchRequest<CompanyCD>(entityName: "CompanyCoreData")
    }

    @NSManaged public var name: String?
    @NSManaged public var ticker: String?
    @NSManaged public var logoURL: String?
    @NSManaged public var isFavorite: Bool
    @NSManaged public var prices: NSSet?

}

// MARK: Generated accessors for prices
extension CompanyCD {

    @objc(addPricesObject:)
    @NSManaged public func addToPrices(_ value: PriceCD)

    @objc(removePricesObject:)
    @NSManaged public func removeFromPrices(_ value: PriceCD)

    @objc(addPrices:)
    @NSManaged public func addToPrices(_ values: NSSet)

    @objc(removePrices:)
    @NSManaged public func removeFromPrices(_ values: NSSet)

}

extension CompanyCD : Identifiable {

}
