//
//  BasicGoodsInfomation.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

protocol BasicGoodsInformation {
    var title: String { get set }
    var price: Int { get set }
    var currency: String { get set }
    var stock: Int { get set }
    var discountedPrice: Int? { get set }
}

protocol Password {
    var password: String { get set }
}

protocol ResponseGoodsInformation: Decodable, BasicGoodsInformation {
    var id: Int { get set }
    var thumbnails: [String] { get set }
    var registrationData: Double { get set }
}

