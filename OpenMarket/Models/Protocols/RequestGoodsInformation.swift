//
//  RequestGoodsInformation.swift
//  OpenMarket
//
//  Created by steven on 9/15/21.
//

import Foundation

protocol Password {
    var password: String { get set }
}

protocol RequestGoodsInformation: BasicGoodsInformation, Password, MultipartForm {
    var descriptions: StringType { get set }
}
