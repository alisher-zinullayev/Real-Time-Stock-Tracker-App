//
//  StockImageService.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

final class StockImageService: StockImageServiceProtocol {
    private let stockImageLoader: StockImageLoaderProtocol
    
    init(stockImageLoader: StockImageLoaderProtocol) {
        self.stockImageLoader = stockImageLoader
    }
    
    func fetchImage(urlString: String, completion: @escaping (Result<UIImage?, ImageLoadError>) -> Void) {
        Task {
            do {
                let image = try await stockImageLoader.fetchImage(urlString: urlString)
                completion(.success(image))
            } catch let error as ImageLoadError {
                completion(.failure(error))
            } catch {
                completion(.failure(.networkError(error)))
            }
        }
    }
}
