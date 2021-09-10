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
    
    // TODO: 중복되는 케이스 합치기
    var url: String {
        switch self {
        case .readList(let page):
            return ServerAPI.baseURL + ServerAPI.listPath + "\(page)"
        case .readItem(let id):
            return ServerAPI.baseURL + ServerAPI.itemPath + "\(id)"
        case .createItem:
            return ServerAPI.baseURL + ServerAPI.itemPath
        case .updateItem(let id):
            return ServerAPI.baseURL + ServerAPI.itemPath + "\(id)"
        case .deleteItem(let id):
            return ServerAPI.baseURL + ServerAPI.itemPath + "\(id)"
        }
    }
    
    var httpMethod: HttpMethod {
        switch self {
        case .readList:
            return .get
        case .readItem:
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
