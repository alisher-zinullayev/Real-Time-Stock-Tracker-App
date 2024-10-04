//
//  StockPriceLoader.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

final class StockPriceLoader: StockPriceLoaderProtocol {
    func fetchStockPrice(ticker: String, completion: @escaping (Result<StockPriceData, NetworkingError>) -> Void) {
        guard let url = URL(string: "\(APIConstants.baseURL)quote?symbol=\(ticker)&token=\(APIConstants.API_KEY)") else {
            completion(.failure(.invalidURL))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }

            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }

            do {
                let decoder = JSONDecoder()
                let stockResponse = try decoder.decode(StockPriceData.self, from: data)
                completion(.success(stockResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        
        task.resume()
    }
}
