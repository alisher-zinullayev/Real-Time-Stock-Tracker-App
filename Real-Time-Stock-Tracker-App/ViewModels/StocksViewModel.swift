//
//  StocksViewModel.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StocksViewModel {
    weak var coordinator: MainCoordinator?
    
    private(set) var stockList = [StockData]()
    private(set) var stockPrices = [String: StockPriceData]()
    
    var showErrorAlert: ((String) -> Void)?
    var reloadTableView: (() -> Void)?
    
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
                self.stockList = stockList
                fetchStockPrices()
            case .failure(let error):
                self.showErrorAlert?("failed to fetch stocks: \(error.localizedDescription)")
            }
        }
    }
    
    func fetchStockPrices() {
        let group = DispatchGroup()
        let lock = NSLock()
        
        for stock in stockList {
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
}
