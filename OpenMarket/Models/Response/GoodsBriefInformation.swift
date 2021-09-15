//
//  GoodsBriefInformation.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

struct GoodsBriefInfomation: ResponseGoodsInformation {
    var id: Int
    var title: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var registrationDate: Double
}
