//
//  NetworkingClient.swift
//  Real-Time-Stock-Tracker-App
//
//  Created by Alisher Zinullayev on 22.11.2024.
//

import Foundation

class NetworkingClient: NetworkClientProtocol {        
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func performRequest<T>(with request: URLRequest, completion: @escaping (Result<T, NetworkingError>) -> Void) where T : Decodable {
        let task = session.dataTask(with: request) { data, response, error in
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
                let decodedResponse = try decoder.decode(T.self, from: data)
                completion(.success(decodedResponse))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
        task.resume()
    }
}
