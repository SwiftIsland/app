//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import Foundation

enum MigrationErrors: Error {
    case unableToEncode
    case errorSaving(OSStatus?)
    case errorLoading(OSStatus?)
    case errorDeleting(OSStatus?)
}

enum KeychainAttrAccount {
    case ticket

    var rawValue: String {
        switch self {
        case .ticket:
            return "ticket"
        }
    }
}

protocol KeychainManaging {
    func get(key: KeychainAttrAccount) throws -> String?
    func delete(key: KeychainAttrAccount) throws
}

class KeychainManager: KeychainManaging {
    static var shared = KeychainManager()

    private var accessGroup: String {
        return "6B3SHVL3L5.nl.swiftisland.app"
    }

    func get(key: KeychainAttrAccount) throws -> String? {
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
            if let result = result as? Data, let value = String(data: result, encoding: .utf8) {
                return value
            }
            return nil
        } else {
            throw MigrationErrors.errorLoading(resultCodeLoad)
        }
    }

    func get<T: Codable>(key: KeychainAttrAccount) throws -> T {

    }

    func get(key: KeychainAttrAccount) throws -> Data {
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
            if let result = result as? Data, let value = String(data: result, encoding: .utf8) {
                return value
            }
            return nil
        } else {
            throw MigrationErrors.errorLoading(resultCodeLoad)
        }
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
}
