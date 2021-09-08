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
    
    func test_NetworkManager_Success_목록조회를_요청했을때_요청한_데이터를_전달한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        let goodsListData = DummyJson.goodsList.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            return (goodsListData, DummyHTTPURLResponse.success, nil)
        }
        
        let expectation = expectation(description: "response success")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, goodsListData)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_NetworkManager_Failure_목록조회를_요청했을때_서버_애러가_발생한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            return (nil, nil, NetworkError.requestError)
        }
        
        let expectation = expectation(description: "response fail")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success:
                XCTFail("request success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.requestError)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
