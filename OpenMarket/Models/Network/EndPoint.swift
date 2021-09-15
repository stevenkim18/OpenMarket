//
//  EndPoint.swift
//  OpenMarket
//
//  Created by steven on 9/7/21.
//

import Foundation

enum EndPoint {
    case readList(Int)
    case readItem(Int)
    case createItem
    case updateItem(Int)
    case deleteItem(Int)
    
    var url: String {
        switch self {
        case .readList(let page):
            return ServerAPI.baseURL + ServerAPI.listPath + "\(page)"
        case .readItem(let id), .updateItem(let id), .deleteItem(let id):
            return ServerAPI.baseURL + ServerAPI.itemPath + "\(id)"
        case .createItem:
            return ServerAPI.baseURL + ServerAPI.itemPath
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .readList, .readItem
            return .get
        case .createItem:
            return .post
        case .updateItem:
            return .patch
        case .deleteItem:
            return .delete
        }
    }
}
