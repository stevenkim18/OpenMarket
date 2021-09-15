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

protocol Stringable {}
protocol Intable {}

extension String: Stringable {}
extension Optional: Stringable where Wrapped == String {}
extension Int: Intable {}
extension Optional: Intable where Wrapped == Int {}
