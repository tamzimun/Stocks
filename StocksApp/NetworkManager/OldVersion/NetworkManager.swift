//
//  NetworkManager.swift
//  StocksApp
//
//  Created by Aida Moldaly on 26.07.2022.
//

import Foundation

protocol Networkable {
    func fetchData<T: Decodable>(path: String, queryItems: [URLQueryItem], completion: @escaping (Result<T, APINetworkError>) -> Void)
}

final class NetworkManager: Networkable {
    
    private let API_KEY = "cblor5iad3ib03etr800"

    static var shared = NetworkManager()
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "finnhub.io"
        components.queryItems = [
            URLQueryItem(name: "token", value: API_KEY)
        ]
        return components
    }()
    
    private let session: URLSession
    
    private init() {
        session = URLSession(configuration: .default)
    }
    
    func fetchData<T: Decodable>(path: String, queryItems: [URLQueryItem], completion: @escaping (Result<T, APINetworkError>) -> Void) {
        var components = urlComponents
        components.path = path
        
        queryItems.forEach { queryItem in
            components.queryItems?.append(queryItem)
        }
        
        guard let url = components.url else {
            completion(.failure(.invalidURL))
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let task = session.dataTask(with: url) { data, response, error in
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
                print("my response is \(String(describing: response))")
                return
            }
            
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
    }
}
