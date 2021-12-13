//
//  RequestSenderMock.swift
//  chat-app-MobiOS-21Tests
//
//  Created by Александр Дергилёв on 11.12.2021.
//

import Foundation
@testable import chat_app_MobiOS_21

class RequestSenderMock: IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        guard config.request.urlRequest != nil else {
            completionHandler(.failure(NetworkError.badURL))
            return
        }
        
        guard let models = config.parser.parse(data: Data()) else {
            completionHandler(.failure(NetworkError.noData))
            return
        }
        
        completionHandler(.success(models))
    }
}
