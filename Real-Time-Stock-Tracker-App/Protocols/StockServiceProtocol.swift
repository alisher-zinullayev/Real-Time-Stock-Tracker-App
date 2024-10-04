//
//  StockServiceProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

protocol StockServiceProtocol {
    func getStockList(completion: @escaping (Result<[StockData], Error>) -> Void)
    func getStockPrice(ticker: String, completion: @escaping (Result<StockPriceData, NetworkingError>) -> Void)
}
