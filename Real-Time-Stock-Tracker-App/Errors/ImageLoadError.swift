//
//  ImageLoadError.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

enum ImageLoadError: Error, LocalizedError {
    case invalidURL(String)
    case invalidResponse(URLResponse)
    case invalidImageData
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL(let urlString):
            return "Invalid URL string: \(urlString)"
        case .invalidResponse(let response):
            return "Invalid response: \(response)"
        case .invalidImageData:
            return "Failed to decode image from data"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        }
    }
}
