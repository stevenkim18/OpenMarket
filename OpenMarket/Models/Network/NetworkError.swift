//
//  NetworkError.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestError
    case invalidURLHTTPResponse
    case invalidHTTPStatusCode(Int)
    case invalidData
}
