//
//  StocksViewModel.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StocksViewModel {
    weak var coordinator: MainCoordinator?
    
    private(set) var allStocks = [StockData]()
    private(set) var favoriteStocks = [StockData]()
    private(set) var filteredStocks = [StockData]()
    private(set) var stockPrices = [String: StockPriceData]()
    
    var showErrorAlert: ((String) -> Void)?
    var reloadTableView: (() -> Void)?
    
    var currentState: CurrentState = .all {
        didSet {
            reloadTableView?()
        }
    }
    
    var currentSearchQuery: String?
    
    private let stockService: StockServiceProtocol
    let stockImageService: StockImageServiceProtocol
    private let stocksRepository: StocksRepositoryProtocol
    
    init(stockService: StockServiceProtocol,
         stockImageService: StockImageServiceProtocol,
         stocksRepository: StocksRepositoryProtocol) {
        self.stockService = stockService
        self.stockImageService = stockImageService
        self.stocksRepository = stocksRepository
    }
    
    func fetchStocks() {
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
                self.fetchStockPrices()
            case .failure(let error):
                self.showErrorAlert?("failed to fetch stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func refreshStocks() {
        fetchStocks()
    }
    
    func fetchStockPrices() {
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
                    self.showErrorAlert?("failed to fetch stock price for \(stock.name) company: \(error.localizedDescription)")
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.reloadTableView?()
        }
    }
    
    func toggleFavorite(for stock: StockData) {
        if isFavorite(stock) {
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
                fetchPrice(for: stock)
            }
        }
        
        stocksRepository.saveContext()
        reloadTableView?()
    }

    
    func isFavorite(_ stock: StockData) -> Bool {
        return favoriteStocks.contains(where: { $0.ticker == stock.ticker })
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
    
    private func fetchPrice(for stock: StockData) {
        stockService.getStockPrice(ticker: stock.ticker) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let priceData):
                guard let company = self.stocksRepository.fetchCompany(by: stock.ticker) else {
                    self.showErrorAlert?("company not found for ticker: \(stock.ticker)")
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
                self.reloadTableView?()
            case .failure(let error):
                self.showErrorAlert?("Failed to fetch price for \(stock.name): \(error.localizedDescription)")
            }
        }
    }
    
//    func filterStocks(with query: String) {
//        if query.isEmpty {
//            currentState = .all
//            filteredStocks.removeAll()
//        } else {
//            filteredStocks = allStocks.filter { stock in
//                stock.name.lowercased().contains(query.lowercased()) ||
//                stock.ticker.lowercased().contains(query.lowercased())
//            }
//            currentState = .searchAll(query)
//        }
//        reloadTableView?()
//    }
    func filterStocks(with query: String) {
        currentSearchQuery = query
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
        reloadTableView?()
    }
    
    func resetSearch() {
        filteredStocks.removeAll()
        switch currentState {
        case .searchAll:
            currentState = .all
        case .searchFavorite:
            currentState = .favorite
        default:
            break
        }
        reloadTableView?()
    }
}
