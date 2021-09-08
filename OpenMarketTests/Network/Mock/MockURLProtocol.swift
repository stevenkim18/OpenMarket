//
//  MockURLProtocol.swift
//  OpenMarketUITests
//
//  Created by steven on 9/8/21.
//

import XCTest
import Foundation

typealias RequestHandlerType = ((URLRequest) throws -> (Data?, HTTPURLResponse?, Error?))

final class MockURLProtocol: URLProtocol {
    static var requestHandler: RequestHandlerType?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable.")
            return
        }
        
        do {
            let (data, response, error) = try handler(self.request)
            
            if let response = response {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            
            // TODO: 여기를 해줘야 함!!!!!!
            if let error = error {
                client?.urlProtocol(self, didFailWithError: error)
            }
            
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        
    }
}
