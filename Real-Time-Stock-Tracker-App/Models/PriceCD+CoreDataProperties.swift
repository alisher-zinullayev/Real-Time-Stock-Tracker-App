//
//  PriceCD+CoreDataProperties.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//
//

import Foundation
import CoreData


extension PriceCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PriceCD> {
        return NSFetchRequest<PriceCD>(entityName: "PriceCoreData")
    }

    @NSManaged public var currentPrice: Double
    @NSManaged public var change: Double
    @NSManaged public var changePercent: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var company: CompanyCD?

}

extension PriceCD : Identifiable {

}
