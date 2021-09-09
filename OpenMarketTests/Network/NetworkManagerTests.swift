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
    
    func test_NetworkManager_Success_상품조회를_요청했을때_요청한_데이터를_전달한다() {
        // given
        let endPoint = EndPoint.readItem(1)
        let readGoodsURL = URL(string: endPoint.url)
        let goodsDetailData = DummyJson.goodsDetail.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readGoodsURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            return (goodsDetailData, DummyHTTPURLResponse.success, nil)
        }
        
        let expectation = expectation(description: "response success")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success(let data):
                XCTAssertEqual(data, goodsDetailData)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_NetworkManager_Success_목록조회를_요청했을때_요청한_데이터를_전달한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        let goodsListData = DummyJson.goodsList.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
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
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
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
    
    func test_NetworkManager_Failure_목록조회를_요청했을때_유효하지않는_응답_애러가_발생한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            return (nil, nil, nil)
        }
        
        let expectation = expectation(description: "response fail")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success:
                XCTFail("request success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidURLHTTPResponse)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_NetworkManager_Failure_목록조회를_요청했을때_HTTP상태코드_애러가_발생한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            return (nil, DummyHTTPURLResponse.fail, nil)
        }
        
        let expectation = expectation(description: "response fail")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success:
                XCTFail("request success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidHTTPStatusCode(404))
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    func test_NetworkManager_Failure_목록조회를_요청했을때_유효하지않는데이터_애러가_발생한다() {
        // given
        let endPoint = EndPoint.readList(1)
        let readListURL = URL(string: endPoint.url)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, readListURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            return (nil, DummyHTTPURLResponse.success, nil)
        }
        
        let expectation = expectation(description: "response fail")
        
        // when
        networkManager.request(endPoint) { result in
            // then
            switch result {
            case .success:
                XCTFail("request success")
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.invalidData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }

}
