//
//  StockImageLoader.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import UIKit

class StockImageLoader: StockImageLoaderProtocol {
    private let imageCache = NSCache<NSString, UIImage>()
    
    func fetchImage(urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString) else {
            throw ImageLoadError.invalidURL(urlString)
        }
        
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw ImageLoadError.invalidResponse(response)
            }
            
            if let image = UIImage(data: data) {
                imageCache.setObject(image, forKey: urlString as NSString)
                return image
            } else {
                throw ImageLoadError.invalidImageData
            }
        } catch {
            throw ImageLoadError.networkError(error)
        }
    }
}
