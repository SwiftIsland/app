import Foundation

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func toData() -> Data? {
        try? JSONSerialization.data(withJSONObject: self)
    }

    func toCodable<T: Codable>(of type: T.Type) -> T? {
        guard let data = toData() else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
