//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import CryptoKit

let encoder = JSONEncoder()
func encrypt<T : Encodable>(value: T, solution: String) throws -> String {
    let json = try encoder.encode(value)
    let key = solution.lowercased().padding(toLength: 32, withPad: " ", startingAt: 0)
    let symmetricKey = SymmetricKey(data: key.data(using: .utf8)!)
    let encryptedData = try ChaChaPoly.seal(json, using: symmetricKey).combined
    let base64 = encryptedData.base64EncodedString()
    return base64
}

let decoder = JSONDecoder()
func decrypt<T : Decodable>(value: String, solution: String, type: T.Type) throws -> T? {
    guard let data = Data(base64Encoded: value.data(using: .utf8)!) else {
        return nil
    }
    let sealedBox = try ChaChaPoly.SealedBox(combined: data)
    let key = solution.lowercased().padding(toLength: 32, withPad: " ", startingAt: 0)
    let symmetricKey = SymmetricKey(data: key.data(using: .utf8)!)
    let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
    let decoded = try JSONDecoder().decode(type, from: decryptedData)
    return decoded
}
