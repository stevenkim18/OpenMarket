//
//  JsonParser.swift
//  OpenMarket
//
//  Created by steven on 9/29/21.
//

import Foundation

struct JsonParser {
    static let shared = JsonParser()
    private let jsonDecoder = JSONDecoder()
    
    private init() {
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func decode<T: Decodable>(with data: Data, by type: T.Type) -> T? {
        guard let instance = try? jsonDecoder.decode(T.self, from: data) else {
            return nil
        }
        return instance
    }
}
