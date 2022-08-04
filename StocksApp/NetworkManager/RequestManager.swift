//
//  RequestManager.swift
//  StocksApp
//
//  Created by Aida Moldaly on 02.08.2022.
//

import Foundation
import UIKit

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol, completion: @escaping (Result<T, APINetworkError>) -> Void)
    func getImage(_ url: String, completion: @escaping (Result<Data, APINetworkError>) -> Void)
}

final class RequestManager: RequestManagerProtocol {
    
    private let session = URLSession(configuration: .default)
    private let API_KEY = "cblnujiad3ib03etqoa0"
    
    func perform<T: Decodable>(_ request: RequestProtocol, completion: @escaping (Result<T, APINetworkError>) -> Void) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        do {
            let task = session.dataTask(with: try request.createURLRequest(authToken: API_KEY)) { data, response, error in
                guard error == nil else {
                    completion(.failure(.failedGET))
                    return
                }
                guard let data = data else {
                    completion(.failure(.dataNotFound))
                    return
                }
                guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                    completion(.failure(.httpRequestFailed))
                    return
                }
                
                let resp = response as? HTTPURLResponse
                print(resp?.statusCode)
                
                do {
                    let result = try decoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(result))
                    }
                    
                } catch {
                    completion(.failure(.decodingError))
                }
            }
            task.resume()
        } catch {
            completion(.failure(.invalidURL))
        }
    }
    
    func getImage(_ url: String, completion: @escaping (Result<Data, APINetworkError>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let dataTask = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(.failedGET))
                return
            }
            guard let data = data else {
                completion(.failure(.dataNotFound))
                return
            }
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                completion(.failure(.httpRequestFailed))
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }
        dataTask.resume()
    }
    
}
