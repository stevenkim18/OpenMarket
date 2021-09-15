//
//  ResponseGoodsInformation.swift
//  OpenMarket
//
//  Created by steven on 9/15/21.
//

import Foundation

protocol ResponseGoodsInformation: Decodable, BasicGoodsInformation {
    var id: Int { get set }
    var thumbnails: [String] { get set }
    var registrationData: Double { get set }
}
