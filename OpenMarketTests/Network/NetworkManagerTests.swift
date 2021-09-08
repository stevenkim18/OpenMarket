//
//  NetworkManagerTests.swift
//  OpenMarketUITests
//
//  Created by steven on 9/7/21.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockUrlSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(session: mockUrlSession)
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
    
    func testNetworkManager_Success_목록조회를_요청했을때() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        let goodsListData = DummyJson.goodsList.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)
            return (goodsListData, response, nil)
        }
        
        let expectation = expectation(description: "response success")
        
        networkManager.request(endPoint) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, goodsListData)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }

}
