//
//  HttpMethod.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

enum HttpMethod: String, CustomStringConvertible {
    case get
    case post
    case patch
    case delete
    
    var description: String {
        return self.rawValue.uppercased()
    }
}
