//
//  BasicGoodsInfomation.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

protocol BasicGoodsInformation {
    associatedtype StringType: Stringable
    associatedtype IntType: Intable
    
    var title: StringType { get set }
    var price: IntType { get set }
    var currency: StringType { get set }
    var stock: IntType { get set }
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

protocol RequestGoodsInformation: BasicGoodsInformation, Password, MutipartForm {
    var descriptions: StringType { get set }
}

protocol Images {
    var images: [Data]? { get set }
}

protocol MutipartForm: Images {
    var mutipartFormData: [String: String] { get }
}

protocol Stringable {}
protocol Intable {}

extension String: Stringable {}
extension Optional: Stringable where Wrapped == String {}
extension Int: Intable {}
extension Optional: Intable where Wrapped == Int {}

// TODO: 파일 분리
