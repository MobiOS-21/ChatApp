//
//  Parser.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 22.11.2021.
//

import Foundation

protocol IParser {
    associatedtype Model
    func parse(data: Data) -> Model?
}

// MARK: - ImagesResponse
struct ImagesResponse: Codable {
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Codable {
    let webformatURL: String
}

class ImageItemParser: IParser {
    typealias Model = ImagesResponse
    func parse(data: Data) -> ImagesResponse? {
        try? JSONDecoder().decode(Model.self, from: data)
    }
}
