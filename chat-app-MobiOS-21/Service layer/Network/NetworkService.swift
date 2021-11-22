//
//  NetworkService.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchImages(completionHandler: @escaping (Result<[URL], Error>) -> Void)
}

class NetwrokService: NetworkServiceProtocol {
    private let requestSender: IRequestSender
    
    init(requestSender: IRequestSender) {
        self.requestSender = requestSender
    }
    
    func fetchImages(completionHandler: @escaping (Result<[URL], Error>) -> Void) {
        requestSender.send(config: RequestFactory.imagesConfig()) { result in
            switch result {
            case .success(let response):
                let urls = response.hits.compactMap({ URL(string: $0.webformatURL) })
                completionHandler(.success(urls))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}
