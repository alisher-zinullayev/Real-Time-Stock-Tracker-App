//
//  NetworkingError.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 04.10.2024.
//

import Foundation

enum NetworkingError: Error {
    case invalidURL
    case networkError(Error)
    case rateLimitExceeded
    case invalidData
    case decodingError(Error)
}
