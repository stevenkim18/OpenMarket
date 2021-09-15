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
        
        let urlRequest = URLRequest(url: url)
        dataTask(with: urlRequest, completion: completion)
    }
    
    func request<T: Encodable>(json: T, _ endPoint: EndPoint, completion: @escaping ResultHandler) {
        guard let url = URL(string: endPoint.url) else {
            return completion(.failure(.invalidURL))
        }
        
        guard let data = try? JSONEncoder().encode(json) else {
            return completion(.failure(.invalidURL))
        }
        
        let urlRequest = generateRequest(with: url, jsonData: data, endPoint)
        dataTask(with: urlRequest, completion: completion)
    }
    
    func upload(form: MutipartForm, _ endPoint: EndPoint, completion: @escaping ResultHandler) {
        guard let url = URL(string: endPoint.url) else {
            return completion(.failure(.invalidURL))
        }
        let urlRequest = generateUploadRequest(with: form, url: url, endPoint)
        dataTask(with: urlRequest, completion: completion)
    }
    
    private func dataTask(with request: URLRequest, completion: @escaping ResultHandler) {
        session.dataTask(with: request) { data, response, error in
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
    
    private func generateUploadRequest(with form: MutipartForm, url: URL, _ endPoint: EndPoint) -> URLRequest {
        let boundary = "Boundary-\(UUID().uuidString)"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(endPoint.httpMethod)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = createHttpBody(form: form, boundary: boundary)
        return urlRequest
    }
    
    private func generateRequest(with url: URL, jsonData: Data, _ endPoint: EndPoint) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "\(endPoint.httpMethod)"
        urlRequest.httpBody = jsonData
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        return urlRequest
    }
    
    private func createHttpBody(form: MutipartForm, boundary: String) -> Data {
        var data = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in form.mutipartFormData {
            data.appendString(boundaryPrefix)
            data.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            data.appendString("\(value)\r\n")
        }
        
        if let images = form.images {
            for imageData in images {
                data.appendString(boundaryPrefix)
                data.appendString("Content-Disposition: form-data; name=\"images[]\"; filename=\"image.jpg\"\r\n")
                data.appendString("Content-Type: image/jpg\r\n\r\n")
                data.append(imageData)
                data.appendString("\r\n")
            }
        }
        
        data.appendString("--".appending(boundary.appending("--")))
        return data
    }
    
}
