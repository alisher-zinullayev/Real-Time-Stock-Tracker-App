//
//  StockService.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StockService: StockServiceProtocol {
    private let stockLocalDataSource: StockLocalDataSourceProtocol
    private let stockPricesLoader: StockPriceLoaderProtocol
    
    init(stockLocalDataSource: StockLocalDataSourceProtocol, stockPricesLoader: StockPriceLoaderProtocol) {
        self.stockLocalDataSource = stockLocalDataSource
        self.stockPricesLoader = stockPricesLoader
    }
    
    func getStockList(completion: @escaping (Result<[StockData], Error>) -> Void) {
        stockLocalDataSource.listStocks { result in
            completion(result)
        }
    }
    
    func getStockPrice(ticker: String, completion: @escaping (Result<StockPriceData, NetworkingError>) -> Void) {
        stockPricesLoader.fetchStockPrice(ticker: ticker) { result in
            completion(result)
        }
    }
}
