//
//  GoodsUpdateForm.swift
//  OpenMarket
//
//  Created by steven on 9/9/21.
//

import Foundation

struct GoodsUpdateForm: RequestGoodsInformation {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [Data]?
    var password: String
    
    var mutipartFormData: [String: String] {
        var datas: [String: String] = [:]
        
        if let title = title {
            datas["title"] = title
        }
        if let descriptions = descriptions {
            datas["descriptions"] = descriptions
        }
        
        if let price = price {
            datas["price"] = "\(price)"
        }
        
        if let currency = currency {
            datas["currency"] = currency
        }
        
        if let stock = stock {
            datas["stock"] = "\(stock)"
        }
        
        if let discountedPrice = discountedPrice {
            datas["discounted_price"] = "\(discountedPrice)"
        }
        
        datas["password"] = password
        
        return datas
    }
}
