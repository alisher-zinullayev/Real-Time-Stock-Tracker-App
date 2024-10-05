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
    private(set) var stockPrices = [String: StockPriceData]()
    
    var showErrorAlert: ((String) -> Void)?
    var reloadTableView: (() -> Void)?
    
    var currentState: CurrentState = .all {
        didSet {
//            fetchStocks()
            reloadTableView?()
        }
    }
    
    private let stockService: StockServiceProtocol
    let stockImageService: StockImageServiceProtocol
    
    init(stockService: StockServiceProtocol, stockImageService: StockImageServiceProtocol) {
        self.stockService = stockService
        self.stockImageService = stockImageService
    }
    
    func fetchStocks() {
        stockService.getStockList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stockList):
                self.allStocks = stockList
                fetchStockPrices()
            case .failure(let error):
                self.showErrorAlert?("failed to fetch stocks: \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchStocks(for state: CurrentState) {
        switch state {
        case .all:
            reloadTableView?()
        case .favorite:
            reloadTableView?()
        }
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
    
    func refreshStocks() {
        stockService.getStockList { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let stockList):
                self.allStocks = stockList
                self.fetchStockPrices()
            case .failure(let error):
                self.showErrorAlert?("Failed to refresh stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func toggleFavorite(for stock: StockData) {
        switch isFavorite(stock) {
        case true:
            if let index = favoriteStocks.firstIndex(where: { $0.ticker == stock.ticker }) {
                favoriteStocks.remove(at: index)
                reloadTableView?()
            }
        case false:
            favoriteStocks.append(stock)
            reloadTableView?()
        }
    }
    
    func isFavorite(_ stock: StockData) -> Bool {
        return favoriteStocks.contains(where: { $0.ticker == stock.ticker })
    }
}
