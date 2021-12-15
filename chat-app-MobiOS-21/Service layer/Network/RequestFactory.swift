//
//  RequestFactory.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

struct RequestFactory {
    static func imagesConfig() -> RequestConfig<ImageItemParser> {
        let request = ImagesRequest(apiKey: API.imageApiKey)
        return RequestConfig(request: request, parser: ImageItemParser())
    }
}
