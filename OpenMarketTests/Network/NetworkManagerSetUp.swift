//
//  NetworkManagerTests.swift
//  OpenMarketUITests
//
//  Created by steven on 9/7/21.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    var networkManager: NetworkManager!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let mockUrlSession = URLSession(configuration: configuration)
        networkManager = NetworkManager(session: mockUrlSession)
    }

    override func tearDownWithError() throws {
        networkManager = nil
    }
}
