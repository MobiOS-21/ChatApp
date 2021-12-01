//
//  ConcurencySender.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 24.11.2021.
//

import Foundation

protocol IConcurrencySender {
    @available(iOS 15.0.0, *)
    func send<Parser>(config: RequestConfig<Parser>) async throws -> Parser.Model
}

class ConcurrencySender: IConcurrencySender {    private let session = URLSession.shared
    @available(iOS 15.0.0, *)
    func send<Parser>(config: RequestConfig<Parser>) async throws -> Parser.Model where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            throw NetworkError.badURL
        }
        let (data, _) = try await session.data(for: urlRequest)
        guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
            throw NetworkError.parsingError
        }
        return parsedModel
    }
}
