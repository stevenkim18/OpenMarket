//
//  RealTest.swift
//  OpenMarketTests
//
//  Created by steven on 9/9/21.
//

import XCTest
@testable import OpenMarket

class RealTest: XCTestCase {

    func testUploadCreateForm() throws {
        let imageData = UIImage(contentsOfFile: "/Users/steven/Desktop/xps.jpg")?.jpegData(compressionQuality: 1.0)
        
        let uploadForm = GoodsCreateForm(title: "다시하는 마음으로",
                                         descriptions: "제발 되라",
                                         price: 100000,
                                         currency: "KRW",
                                         stock: 10,
                                         discountedPrice: 99999,
                                         images: [imageData!],
                                         password: "1234")
        
        let expectation = expectation(description: "upload")
        
        NetworkManager().upload(form: uploadForm, EndPoint.createItem) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(String(decoding: data, as: UTF8.self))
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testUploadUpdateForm() throws {
        let uploadForm = GoodsUpdateForm(title: "다시하는 마음으로123123123",
                                         descriptions: nil,
                                         price: nil,
                                         currency: nil,
                                         stock: nil,
                                         discountedPrice: nil,
                                         images: nil,
                                         password: "1234")
        
        let expectation = expectation(description: "upload")
        
        NetworkManager().upload(form: uploadForm, EndPoint.updateItem(331)) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(String(decoding: data, as: UTF8.self))
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
    /// 1기 서버는 id와 패스워드를 같이 요청해야하다
    /// 성공하면 응답으로 id만 온다.
    func testDeleteUpdateForm() throws {
        let deleteForm = GoodsDeleteForm(password: "1234")
        
        let expectation = expectation(description: "delete request")
        
        NetworkManager().request(json: deleteForm, EndPoint.deleteItem(331)) { result in
            switch result {
            case .success(let data):
                XCTAssertNil(String(decoding: data, as: UTF8.self))
            case .failure(let error):
                XCTAssertNil(error)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
    
}
