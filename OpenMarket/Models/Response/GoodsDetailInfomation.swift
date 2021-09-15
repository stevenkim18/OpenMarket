//
//  GoodsDetail.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

struct GoodsDetailInformation: ResponseGoodsInformation {
    var id: Int
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var thumbnails: [String]
    var images: [String]
    var registrationDate: Double
}
