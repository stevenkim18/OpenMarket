//
//  GoodsCreateForm.swift
//  OpenMarket
//
//  Created by steven on 9/9/21.
//

import Foundation

struct GoodsCreateForm: RequestGoodsInformation {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [Data]?
    var password: String
    
    var mutipartFormData: [String: String] {
        var datas: [String: String] = [:]
        datas["title"] = title
        datas["descriptions"] = descriptions
        datas["price"] = String(price)
        datas["currency"] = currency
        datas["stock"] = String(stock)
        if let discountedPrice = discountedPrice {
            datas["discounted_price"] = String(discountedPrice)
        }
        datas["password"] = password
        return datas
    }
}
