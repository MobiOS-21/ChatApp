//
//  RequestFactory.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

struct RequestFactory {
    static func imagesConfig() -> RequestConfig<ImageItemParser> {
        let request = ImagesRequest(apiKey: "24467046-584c5a0196d90873622b960e0")
        return RequestConfig(request: request, parser: ImageItemParser())
    }
}
