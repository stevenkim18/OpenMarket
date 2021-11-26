//
//  GoodsList.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

struct GoodsList: Decodable {
    let page: Int
    let items: [GoodsBriefInfomation]
}
