//
//  MultipartForm.swift
//  OpenMarket
//
//  Created by steven on 9/15/21.
//

import Foundation

protocol Images {
    var images: [Data]? { get set }
}

protocol MultipartForm: Images {
    var mutipartFormData: [String: String] { get }
}
