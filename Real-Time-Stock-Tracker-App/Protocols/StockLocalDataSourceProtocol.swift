//
//  StockLocalDataSourceProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

protocol StockLocalDataSourceProtocol {
    func listStocks(completion: @escaping (Result<[StockData], Error>) -> Void)
}
