//
//  Configuration.swift
//  chat-app-MobiOS-21
//
//  Created by Александр Дергилёв on 15.12.2021.
//

import Foundation

enum Configuration {
    enum Error: Swift.Error {
        case missingKey, invalidValue
    }
    
    static func value<T>(for key: String) throws -> T where T: LosslessStringConvertible {
        guard let object = Bundle.main.object(forInfoDictionaryKey: key) else {
            throw Error.missingKey
        }
        
        switch object {
        case let value as T:
            return value
        case let string as String:
            guard let value = T(string) else { fallthrough }
            return value
        default:
            throw Error.invalidValue
        }
    }
}

enum API {
    static var imageURL: String {
        do {
            return try Configuration.value(for: "IMAGE_URL")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    static var imageApiKey: String {
        do {
            return try Configuration.value(for: "IMAGE_API_KEY")
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
