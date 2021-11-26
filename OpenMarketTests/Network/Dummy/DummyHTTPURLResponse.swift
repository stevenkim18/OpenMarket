//
//  DummyHTTPURLResponse.swift
//  OpenMarketTests
//
//  Created by steven on 9/8/21.
//

import Foundation

struct DummyHTTPURLResponse {
    static let success = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                         statusCode: 200,
                                         httpVersion: nil,
                                         headerFields: nil)
    static let fail = HTTPURLResponse(url: URL(fileURLWithPath: ""),
                                      statusCode: 404,
                                      httpVersion: nil,
                                      headerFields: nil)
}
