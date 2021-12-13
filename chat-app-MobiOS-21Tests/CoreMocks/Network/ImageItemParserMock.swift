//
//  ImageItemParserMock.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 11.12.2021.
//

import Foundation
@testable import chat_app_MobiOS_21

class ImageItemParserMock: IParser {
    typealias Model = ImagesResponse
    private let mockResponse: ImagesResponse?
    
    init(mockResponse: ImagesResponse?) {
        self.mockResponse = mockResponse
    }
    
    func parse(data: Data) -> ImagesResponse? {
        mockResponse
    }
}
