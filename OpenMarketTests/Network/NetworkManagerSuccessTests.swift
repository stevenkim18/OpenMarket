//
//  NetworkManagerSuccessTests.swift
//  OpenMarketTests
//
//  Created by steven on 9/10/21.
//

import XCTest
@testable import OpenMarket

extension NetworkManagerTests {
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
    
    func test_NetworkManager_Success_상품등록을_요청했을떄_업로드가_성공하고_json데이터를_응답한다() {
        // given
        let endPoint = EndPoint.createItem
        let createGoodsURL = URL(string: endPoint.url)
        let responseGoodsData = DummyJson.successDetail.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, createGoodsURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            XCTAssertFalse(request.extractHttpBody().isEmpty)
            return (responseGoodsData, DummyHTTPURLResponse.success, nil)
        }
        
        let expectation = expectation(description: "upload success")
        
        networkManager.upload(form: DummyModel.createForm, endPoint) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, responseGoodsData)
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    // TODO: 실제 httpbody 바디 파서를 구현해서 기존의 모델과 비교하고 업데이트한 값을 리턴하는 함수 구현
    // 현재는 성공하는 데이터를 넘겨줌.
    func test_NetworkManager_Success_상품수정을_요청했을떄_성공하고_변경된_json데이터를_응답한다() {
        // given
        let id = 100
        let endPoint = EndPoint.updateItem(id)
        let updateGoodsURL = URL(string: endPoint.url)
//        let existingModel = DummyModel.makeDetailModel(with: id)
        let updateRequestModel = DummyModel.updateForm

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, updateGoodsURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            XCTAssertFalse(request.extractHttpBody().isEmpty)
            return (DummyJson.successDetail.data(using: .utf8), DummyHTTPURLResponse.success, nil)
        }

        let expectation = expectation(description: "upload success")

        networkManager.upload(form: updateRequestModel, endPoint) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, DummyJson.successDetail.data(using: .utf8))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
    
    func test_NetworkManager_Success_상품삭제을_요청했을떄_성공하고_삭제된_json데이터를_응답한다() {
        // given
        let id = 100
        let endPoint = EndPoint.deleteItem(id)
        let deleteGoodsURL = URL(string: endPoint.url)
        let deleteRequestModel = GoodsDeleteForm(id: id, password: "1234")

        MockURLProtocol.requestHandler = { request in
            XCTAssertEqual(request.url, deleteGoodsURL)
            XCTAssertEqual(request.httpMethod, "\(endPoint.httpMethod)")
            // TODO: 나중에 url에 있는 아이디와 바디에 있는 id를 비교해도 좋을 듯
            XCTAssertFalse(request.extractHttpBody().isEmpty)
            return (DummyJson.successDetail.data(using: .utf8), DummyHTTPURLResponse.success, nil)
        }

        let expectation = expectation(description: "upload success")

        networkManager.request(json: deleteRequestModel, endPoint) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data, DummyJson.successDetail.data(using: .utf8))
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
    }
}
