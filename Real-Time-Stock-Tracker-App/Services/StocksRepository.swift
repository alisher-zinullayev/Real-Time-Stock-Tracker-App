//
//  StocksRepository.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//

import Foundation
import CoreData

class StocksRepository: StocksRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = CoreDataStack.shared.viewContext) {
        self.context = context
    }
    
    func fetchAllCompanies() -> [CompanyCD] {
        let fetchRequest: NSFetchRequest<CompanyCD> = CompanyCD.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("error fetching all companies: \(error.localizedDescription)")
            return []
        }
    }
    
    func fetchFavoriteCompanies() -> [CompanyCD] {
        let fetchRequest: NSFetchRequest<CompanyCD> = CompanyCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("error fetching favorite companies: \(error.localizedDescription)")
            return []
        }
    }
    
    func addCompany(name: String, ticker: String, logoURL: String?, isFavorite: Bool) -> CompanyCD {
        let company = CompanyCD(context: context)
        company.name = name
        company.ticker = ticker
        company.logoURL = logoURL
        company.isFavorite = isFavorite
        
        saveContext()
        return company
    }
    
    func addPrice(for company: CompanyCD, currentPrice: Double, change: Double, changePercent: Double, timestamp: Date) -> PriceCD {
        let price = PriceCD(context: context)
        price.currentPrice = currentPrice
        price.change = change
        price.changePercent = changePercent
        price.timestamp = timestamp
        price.company = company
        
        company.addToPrices(price)
        
        saveContext()
        return price
    }
    
    func updateCompany(_ company: CompanyCD, isFavorite: Bool) {
        company.isFavorite = isFavorite
        saveContext()
    }
    
    func fetchCompany(by ticker: String) -> CompanyCD? {
        let fetchRequest: NSFetchRequest<CompanyCD> = CompanyCD.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "ticker == %@", ticker)
        fetchRequest.fetchLimit = 1

        do {
            let results = try context.fetch(fetchRequest)
            if let company = results.first {
                return company
            } else {
                print("no company found with ticker: \(ticker)")
                return nil
            }
        } catch {
            print("error fetching company by ticker: \(error.localizedDescription)")
            return nil
        }
    }
    
    func saveContext() {
        do {
            try context.save()
        } catch {
            print("error saving context: \(error.localizedDescription)")
        }
    }
}
