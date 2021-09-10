//
//  URLRequest+HTTPbody.swift
//  OpenMarketTests
//
//  Created by steven on 9/10/21.
//

import Foundation

extension URLRequest {
    func extractHttpBody() -> Data {
        guard let bodyStream = self.httpBodyStream else {
            return Data()
        }
        
        bodyStream.open()
        
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        
        var data = Data()
        while bodyStream.hasBytesAvailable {
            let readData = bodyStream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readData)
        }
        
        buffer.deallocate()
        bodyStream.close()
        return data
    }
}
