//
//  StocksRepositoryProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 06.10.2024.
//

import Foundation
import CoreData

protocol StocksRepositoryProtocol {
    func fetchAllCompanies() -> [CompanyCD]
    func fetchFavoriteCompanies() -> [CompanyCD]
    func fetchCompany(by ticker: String) -> CompanyCD?
    
    func addCompany(name: String, ticker: String, logoURL: String?, isFavorite: Bool) -> CompanyCD
    func addPrice(for company: CompanyCD, currentPrice: Double, change: Double, changePercent: Double, timestamp: Date) -> PriceCD
    
    func updateCompany(_ company: CompanyCD, isFavorite: Bool)
    
    func saveContext()
}
