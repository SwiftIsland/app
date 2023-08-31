//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

enum MigrationErrors: Error {
    case unableToEncode
    case errorSaving(OSStatus?)
    case errorLoading(OSStatus?)
    case errorDeleting(OSStatus?)
}

enum KeychainAttrAccount {
    case tickets

    var rawValue: String {
        switch self {
        case .tickets:
            return "tickets"
        }
    }
}

protocol KeychainManaging {
    func get(key: KeychainAttrAccount) throws -> String?
    func get<T: Decodable>(key: KeychainAttrAccount) throws -> T?
    func delete(key: KeychainAttrAccount) throws
    func store<T: Encodable>(key: KeychainAttrAccount, data: T) throws
}

class KeychainManager: KeychainManaging {
    static var shared = KeychainManager()

    private var accessGroup: String {
        return "V38QRBT6X5.nl.swiftisland.app"
    }

    func get(key: KeychainAttrAccount) throws -> String? {
        guard let data: Data = try get(key: key) else { return nil }
        if let value = String(data: data, encoding: .utf8) {
            return value
        }

        return nil
    }

    func get<T: Decodable>(key: KeychainAttrAccount) throws -> T? {
        guard let data: Data = try get(key: key) else { return nil }

        return try JSONDecoder().decode(T.self, from: data)
    }

    func delete(key: KeychainAttrAccount) throws {
        let queryDelete = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecAttrAccessGroup: accessGroup
        ] as [String: Any]

        let result = SecItemDelete(queryDelete as CFDictionary)

        if result != noErr && result != errSecItemNotFound {
            throw MigrationErrors.errorDeleting(result)
        }
    }

    func store<T: Encodable>(key: KeychainAttrAccount, data: T) throws {
        let data = try JSONEncoder().encode(data)

        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecValueData: data,
            kSecAttrAccessGroup: accessGroup
        ] as [String: Any]
        SecItemDelete(query as CFDictionary)

        let result = SecItemAdd(query as CFDictionary, nil)

        if result != noErr {
            throw MigrationErrors.errorSaving(result)
        }
    }
}

private extension KeychainManager {
    func get(key: KeychainAttrAccount) throws -> Data? {
        let queryLoad = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key.rawValue,
            kSecReturnData: kCFBooleanTrue as Any,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecAttrAccessGroup: accessGroup
        ] as [String: Any]

        var result: AnyObject?

        let resultCodeLoad = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(queryLoad as CFDictionary, UnsafeMutablePointer($0))
        }

        if resultCodeLoad == noErr {
            if let data = result as? Data {
                return data
            }
            return nil
        } else {
            throw MigrationErrors.errorLoading(resultCodeLoad)
        }
    }
}
