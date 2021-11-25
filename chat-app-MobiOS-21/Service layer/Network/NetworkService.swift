//
//  NetworkService.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    func fetchImages(completionHandler: @escaping (Result<[URL], Error>) -> Void)
    @available(iOS 15.0.0, *)
    func fetchConcurencyImages() async throws -> [URL]
}

class NetwrokService: NetworkServiceProtocol {
    private let requestSender: IRequestSender
    private let concurencySender: IConcurrencySender
    
    init(requestSender: IRequestSender, concurencySender: IConcurrencySender) {
        self.requestSender = requestSender
        self.concurencySender = concurencySender
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
    
    @available(iOS 15.0.0, *)
    func fetchConcurencyImages() async throws -> [URL] {
        try await concurencySender.send(config: RequestFactory.imagesConfig())
            .hits.compactMap({ URL(string: $0.webformatURL) })
    }
}
