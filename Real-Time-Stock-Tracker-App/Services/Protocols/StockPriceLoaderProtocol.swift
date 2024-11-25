//
//  StockPriceLoaderProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

protocol StockPriceLoaderProtocol {
    func fetchStockPrice(ticker: String, completion: @escaping (Result<StockPriceData, NetworkingError>) -> Void)
}
