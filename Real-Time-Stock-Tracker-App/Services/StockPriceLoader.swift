//
//  StockPriceLoader.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StockPriceLoader: StockPriceLoaderProtocol {
    private let networkClient: NetworkClientProtocol
    
    init(networkClient: NetworkClientProtocol = NetworkingClient()) {
        self.networkClient = networkClient
    }
    
    func fetchStockPrice(ticker: String, completion: @escaping (Result<StockPriceData, NetworkingError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.baseURL)quote?symbol=\(ticker)&token=\(APIConstants.API_KEY)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        networkClient.performRequest(with: request) { (result: Result<StockPriceData, NetworkingError>) in
            completion(result)
        }
    }
}
