//
//  TestNetworkService.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 12.12.2021.
//

import XCTest
@testable import chat_app_MobiOS_21

class TestNetworkService: XCTestCase {
    func testFailureNetworkRequest() {
        let requestSender = RequestSenderMock()
        let concurencySender = ConcurrencySender()
        let networkService = NetwrokService(requestSender: requestSender, concurencySender: concurencySender)
        
        networkService.fetchImages { result in
            switch result {
            case .success:
                XCTFail("Test error")
            case .failure(let error):
                XCTAssertEqual(NetworkError.noData.errorDescription, error.localizedDescription)
            }
        }
    }
}
