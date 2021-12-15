//
//  Request.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

protocol IRequest {
    var urlRequest: URLRequest? { get }
}

struct RequestConfig<Parser> where Parser: IParser {
    let request: IRequest
    let parser: Parser
}

class ImagesRequest: IRequest {
    var urlRequest: URLRequest?
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
        generateRequest()
    }
    
    private func generateRequest() {
        guard var urlComponents = URLComponents(string: API.imageURL) else { return }
        urlComponents.queryItems = [URLQueryItem(name: "key", value: apiKey),
        URLQueryItem(name: "per_page", value: "200")]
        guard let url = urlComponents.url else { return }
        urlRequest = URLRequest(url: url)
    }
}
