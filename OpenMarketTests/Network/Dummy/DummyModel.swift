//
//  DummyForm.swift
//  OpenMarketTests
//
//  Created by steven on 9/9/21.
//

import UIKit
@testable import OpenMarket

struct DummyModel {
    private static let sampleImageData = UIImage(named: "sample")?.jpegData(compressionQuality: 1.0)
    
    static let createForm = GoodsCreateForm(title: "델XPS",
                                            descriptions: "맥북의 대항마",
                                            price: 1399,
                                            currency: "USD",
                                            stock: 10,
                                            discountedPrice: 1299,
                                            images: [sampleImageData!],
                                            password: "1234")
    
    static let updateForm = GoodsUpdateForm(title: "제목 수정",
                                            descriptions: nil,
                                            price: nil,
                                            currency: nil,
                                            stock: nil,
                                            discountedPrice: nil,
                                            images: nil,
                                            password: "1234")
    
    static func makeDetailModel(with id: Int) -> GoodsDetailInformation {
        return GoodsDetailInformation(id: id,
                                      title: "테스트 제목",
                                      descriptions: "테스트 설명",
                                      price: 1000,
                                      currency: "KRW",
                                      stock: 100,
                                      discountedPrice: 900,
                                      thumbnails: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"],
                                      images: ["https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png"],
                                      registrationData: 10000000.0)
    }
}

extension GoodsDetailInformation: Encodable {}
