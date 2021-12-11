//
//  TestNetworkService.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 11.12.2021.
//

import XCTest
@testable import chat_app_MobiOS_21

class TestNetworkService: XCTestCase {
    func testBadURLRequest() {
        let imageRequest = ImageRequestMock()
        let imageItemParser = ImageItemParserMock(mockResponse: nil)
        let requestSender = RequestSenderMock()
        
        requestSender.send(config: RequestConfig(request: imageRequest, parser: imageItemParser)) { result in
            switch result {
            case .success:
                XCTFail("Test error")
            case .failure(let error):
                XCTAssertEqual(NetworkError.badURL.errorDescription, error.localizedDescription)
            }
        }
    }
    
    func testNoDataRequest() {
        guard let url = URL(string: "www.test.com") else {
            XCTFail("Bad URL")
            return
        }
        let imageRequest = ImageRequestMock()
        imageRequest.urlRequest = URLRequest(url: url)
        let imageItemParser = ImageItemParserMock(mockResponse: nil)
        let requestSender = RequestSenderMock()
        
        requestSender.send(config: RequestConfig(request: imageRequest, parser: imageItemParser)) { result in
            switch result {
            case .success:
                XCTFail("Test error")
            case .failure(let error):
                XCTAssertEqual(NetworkError.noData.errorDescription, error.localizedDescription)
            }
        }
    }
    
    func testCorrectRequest() {
        guard let url = URL(string: "www.test.com") else {
            XCTFail("Bad URL")
            return
        }
        let mockResponse = ImagesResponse(hits: [Hit(webformatURL: "www.test.com")])
        let imageRequest = ImageRequestMock()
        imageRequest.urlRequest = URLRequest(url: url)
        let imageItemParser = ImageItemParserMock(mockResponse: mockResponse)
        let requestSender = RequestSenderMock()
        
        requestSender.send(config: RequestConfig(request: imageRequest, parser: imageItemParser)) { result in
            switch result {
            case .success(let response):
                XCTAssertEqual(mockResponse.hits.count, response.hits.count)
                XCTAssertEqual(mockResponse.hits.first?.webformatURL, response.hits.first?.webformatURL)
            case .failure:
                XCTFail("Test error")
            }
        }
    }
}
