//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

struct NetworkManager {
    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func request(_ endPoint: EndPoint, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: endPoint.url) else {
            return completion(.failure(fatalError()))
        }
        let urlRequest = generateRequest(with: url, endPoint)
        _ = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(fatalError()))
            }
            guard let response = response as? HTTPURLResponse else {
                return completion(.failure(fatalError()))
            }
            guard (200...399).contains(response.statusCode) else {
                return completion(.failure(fatalError()))
            }
            guard let data = data else {
                return completion(.failure(fatalError()))
            }
            completion(.success(data))
        }
    }
    
    private func generateRequest(with url: URL, _ endPoint: EndPoint) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(endPoint.httpMethod)"
        return urlRequest
    }
    
//    private func createHttpBody
    
}
