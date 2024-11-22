//
//  NetworkClientProtocol.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 22.11.2024.
//

import Foundation

protocol NetworkClientProtocol {
    func performRequest<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, NetworkingError>) -> Void)
}
