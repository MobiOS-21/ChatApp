//
//  RequestSender.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case parsingError
    case serverError
    case noData
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noData:
            return "Received neither error nor data"
        case .parsingError:
            return "Got data in unexpected format, it might be error description"
        case .badURL:
            return "URL is incorrect :("
        case .serverError:
            return "Server error"
        }
    }
}

protocol IRequestSender {
    func send<Parser>(config: RequestConfig<Parser>, completionHandler: @escaping (Result<Parser.Model, Error>) -> Void)
}

class RequestSender: IRequestSender {
    private let session = URLSession.shared
    
    func send<Parser>(config: RequestConfig<Parser>,
                      completionHandler: @escaping (Result<Parser.Model, Error>) -> Void) where Parser: IParser {
        guard let urlRequest = config.request.urlRequest else {
            completionHandler(.failure(NetworkError.badURL))
            return
        }
        let task = session.dataTask(with: urlRequest) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            
            guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else {
                completionHandler(.failure(NetworkError.serverError))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            guard let parsedModel: Parser.Model = config.parser.parse(data: data) else {
                completionHandler(.failure(NetworkError.parsingError))
                return
            }
            completionHandler(.success(parsedModel))
        }
        task.resume()
    }
}
