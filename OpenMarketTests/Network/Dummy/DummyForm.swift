//
//  DummyForm.swift
//  OpenMarketTests
//
//  Created by steven on 9/9/21.
//

import UIKit
@testable import OpenMarket

struct DummyForm {
    private static let sampleImageData = UIImage(named: "sample")?.jpegData(compressionQuality: 1.0)
    static let createForm = GoodsCreateForm(title: "델XPS",
                                            descriptions: "맥북의 대항마",
                                            price: 1399,
                                            currency: "USD",
                                            stock: 10,
                                            discountedPrice: 1299,
                                            images: [sampleImageData!],
                                            password: "1234")
}
