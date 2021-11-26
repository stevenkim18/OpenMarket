//
//  Data+String.swift
//  OpenMarket
//
//  Created by steven on 9/9/21.
//

import Foundation

extension Data {
    mutating func appendString(_ string: String) {
        guard let stringData = string.data(using: .utf8) else { return }
        append(stringData)
    }
}
