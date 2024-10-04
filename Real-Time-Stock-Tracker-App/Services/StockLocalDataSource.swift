//
//  StocksLocalDataSource.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StockLocalDataSource: StockLocalDataSourceProtocol {
    func listStocks(completion: @escaping (Result<[StockData], any Error>) -> Void) {
        guard let path = Bundle.main.path(forResource: "stockProfiles", ofType: "json") else {
            completion(.failure(NSError(domain: "StockLocalDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "stockProfiles.json not found"])))
            return
        }
        
        do {
            let url = URL(fileURLWithPath: path)
            let data = try Data(contentsOf: url, options: .mappedIfSafe)
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let stocks = try jsonDecoder.decode([StockData].self, from: data)
            completion(.success(stocks))
        } catch {
            completion(.failure(error))
        }
    }
}
