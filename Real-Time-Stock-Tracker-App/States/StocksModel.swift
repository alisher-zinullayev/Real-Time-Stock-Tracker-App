//
//  StocksModel.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 23.11.2024.
//

import Foundation
import UIKit

final class StocksModel {
    var allStocks = [StockData]()
    var favoriteStocks = [StockData]()
    var filteredStocks = [StockData]()
    var stockPrices = [String: StockPriceData]()
    
    private let stocksRepository: StocksRepositoryProtocol
    
    init(stocksRepository: StocksRepositoryProtocol) {
        self.stocksRepository = stocksRepository
    }
    
    func fetchStocks(stockService: StockServiceProtocol, completion: @escaping (Result<Void, Error>) -> Void) {
        stockService.getStockList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stockList):
                let companyCDs = self.stocksRepository.fetchAllCompanies()
                self.allStocks = companyCDs.map { company in
                    StockData(
                        name: company.name ?? "Unnamed Company",
                        ticker: company.ticker ?? "N/A",
                        logo: company.logoURL ?? "",
                        isFavorite: company.isFavorite
                    )
                }
                
                let favoriteCompanyCDs = self.stocksRepository.fetchFavoriteCompanies()
                self.favoriteStocks = favoriteCompanyCDs.map { companyCD in
                    StockData(
                        name: companyCD.name ?? "Unnamed Company",
                        ticker: companyCD.ticker ?? "N/A",
                        logo: companyCD.logoURL ?? "",
                        isFavorite: companyCD.isFavorite
                    )
                }
                
                self.updateStocks(with: stockList)
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func updateStocks(with stockList: [StockData]) {
        for stock in stockList {
            if let existingCompany = allStocks.first(where: { $0.ticker == stock.ticker }) {
                existingCompany.name = stock.name
                existingCompany.logo = stock.logo
            } else {
                _ = stocksRepository.addCompany(
                    name: stock.name,
                    ticker: stock.ticker,
                    logoURL: stock.logo,
                    isFavorite: false
                )
            }
        }
        stocksRepository.saveContext()
    }
    
    func fetchStockPrices(stockService: StockServiceProtocol, completion: @escaping () -> Void) {
        let group = DispatchGroup()
        let lock = NSLock()
        
        for stock in allStocks {
            group.enter()
            stockService.getStockPrice(ticker: stock.ticker) { [weak self] result in
                guard let self = self else {
                    group.leave()
                    return
                }
                switch result {
                case .success(let prices):
                    lock.lock()
                    self.stockPrices[stock.ticker] = prices
                    lock.unlock()
                case .failure(let error):
                    print("failed fetching stock price for \(stock.name): \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            completion()
        }
    }
    
    func toggleFavorite(for ticker: String, stockService: StockServiceProtocol, completion: @escaping () -> Void) {
        guard let stock = allStocks.first(where: { $0.ticker == ticker }) else {
            completion()
            return
        }
        
        if isFavorite(stock.ticker) {
            if let index = favoriteStocks.firstIndex(where: { $0.ticker == stock.ticker }) {
                favoriteStocks.remove(at: index)
            }
            
            if let company = stocksRepository.fetchCompany(by: stock.ticker) {
                stocksRepository.updateCompany(company, isFavorite: false)
            }
        } else {
            favoriteStocks.append(stock)
            
            if let company = stocksRepository.fetchCompany(by: stock.ticker) {
                stocksRepository.updateCompany(company, isFavorite: true)
                fetchPrice(for: stock, stockService: stockService)
            }
        }
        
        stocksRepository.saveContext()
        completion()
    }
    
    private func fetchPrice(for stock: StockData, stockService: StockServiceProtocol) {
        stockService.getStockPrice(ticker: stock.ticker) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let priceData):
                guard let company = self.stocksRepository.fetchCompany(by: stock.ticker) else {
                    print("Company not found for ticker: \(stock.ticker)")
                    return
                }
                _ = self.stocksRepository.addPrice(
                    for: company,
                    currentPrice: priceData.currentPrice ?? 0,
                    change: priceData.change ?? 0,
                    changePercent: priceData.changePercent ?? 0,
                    timestamp: Date()
                )
                self.stockPrices[stock.ticker] = priceData
            case .failure(let error):
                print("failed fetching price for \(stock.name): \(error.localizedDescription)")
            }
        }
    }
    
    func isFavorite(_ ticker: String) -> Bool {
        return favoriteStocks.contains(where: { $0.ticker == ticker })
    }
    
    func filterStocks(with query: String, currentState: inout CurrentState) {
        if query.isEmpty {
            switch currentState {
            case .searchAll:
                currentState = .all
            case .searchFavorite:
                currentState = .favorite
            default:
                break
            }
            filteredStocks.removeAll()
        } else {
            switch currentState {
            case .all, .searchAll:
                filteredStocks = allStocks.filter { stock in
                    stock.name.lowercased().contains(query.lowercased()) ||
                    stock.ticker.lowercased().contains(query.lowercased())
                }
                currentState = .searchAll(query)
            case .favorite, .searchFavorite:
                filteredStocks = favoriteStocks.filter { stock in
                    stock.name.lowercased().contains(query.lowercased()) ||
                    stock.ticker.lowercased().contains(query.lowercased())
                }
                currentState = .searchFavorite(query)
            }
        }
    }
    
    func resetSearch(currentState: inout CurrentState) {
        filteredStocks.removeAll()
        switch currentState {
        case .searchAll:
            currentState = .all
        case .searchFavorite:
            currentState = .favorite
        default:
            break
        }
    }
    
    func cellModel(for indexPath: IndexPath, currentState: CurrentState) -> StocksTableViewCell.Model {
        let stock: StockData
        
        switch currentState {
        case .all, .searchAll:
            stock = filteredStocks.isEmpty ? allStocks[indexPath.row] : filteredStocks[indexPath.row]
        case .favorite, .searchFavorite:
            stock = filteredStocks.isEmpty ? favoriteStocks[indexPath.row] : filteredStocks[indexPath.row]
        }
        
        let priceModel = stockPrices[stock.ticker]
        
        let currentPrice: String
        let percentPrice: String
        let percentPriceColor: UIColor
        let imageName = stock.isFavorite ? "Favorite" : "NotFavorite"
        let containerBackgroundColor = isEven(indexPath.row) ? UIColor.myGrayColor : UIColor.myWhiteColor
        
        if let price = priceModel {
            if let newPrice = price.currentPrice {
                currentPrice = String(format: "$%.2f", newPrice)
            } else {
                currentPrice = "--"
            }
            if let change = price.change, let changePercent = price.changePercent {
                percentPrice = String(format: "%+.2f (%.2f%%)", change, changePercent)
                percentPriceColor = change >= 0 ? .systemGreen : .systemRed
            } else {
                percentPrice = "--"
                percentPriceColor = .black
            }
        } else {
            currentPrice = "--"
            percentPrice = "--"
            percentPriceColor = .black
        }
        
        return .init(
            name: stock.name,
            abbreviation: stock.ticker,
            logoURL: stock.logo,
            currentPrice: currentPrice,
            percentPrice: percentPrice,
            percentPriceColor: percentPriceColor,
            favoriteImageName: imageName,
            containerBackgroundColor: containerBackgroundColor
        )
    }
    
    private func isEven(_ index: Int) -> Bool {
        return index % 2 == 0
    }
}
