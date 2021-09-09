//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

typealias ResultHandler = (Result<Data, NetworkError>) -> Void

struct NetworkManager {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(_ endPoint: EndPoint, completion: @escaping ResultHandler) {
        guard let url = URL(string: endPoint.url) else {
            return completion(.failure(.invalidURL))
        }
        
        let urlRequest = generateRequest(with: url, endPoint)
        
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(.requestError))
            }
            
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(.invalidURLHTTPResponse))
            }
            
            guard (200...399).contains(response.statusCode) else {
                return completion(.failure(.invalidHTTPStatusCode(response.statusCode)))
            }
            
            guard let data = data, !data.isEmpty else {
                return completion(.failure(.invalidData))
            }
            
            completion(.success(data))
            
        }.resume()
    }
    
    private func generateRequest(with url: URL, _ endPoint: EndPoint) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(endPoint.httpMethod)"
        return urlRequest
    }
    
//    private func createHttpBody
    
}
