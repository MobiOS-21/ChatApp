//
//  Codable+extension.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 26.10.2021.
//

import Foundation

extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSONEncoder().encode(self))) as? [String: Any] ?? [:]
    }
}
