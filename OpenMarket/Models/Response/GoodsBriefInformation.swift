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
    
    var stockText: String {
        if stock == 0 {
            return "품절"
        } else if stock > 999 {
            return "잔여수량: 999+"
        } else {
            return "잔여수량: \(stock)"
        }
    }
    
    var priceText: String {
        return "\(currency) \(price) "
    }
    
    var discountedPriceText: String {
        return "\(currency) \(discountedPrice!) "
    }
}
