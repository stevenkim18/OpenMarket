//
//  NetworkError.swift
//  OpenMarketTests
//
//  Created by steven on 9/8/21.
//

import Foundation
@testable import OpenMarket

extension NetworkError: Equatable {
    public static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        return String(reflecting: lhs) == String(reflecting: rhs)
    }
}
