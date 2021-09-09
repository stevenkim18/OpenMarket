//
//  RealTest.swift
//  OpenMarketTests
//
//  Created by steven on 9/9/21.
//

import XCTest
@testable import OpenMarket

class RealTest: XCTestCase {

    func testExample() throws {
        
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
}
