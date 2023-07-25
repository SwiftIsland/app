import Foundation
import Firebase

extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    func toData() -> Data? {
        var dict = self

        dict.filter {
            $0.value is Date || $0.value is Timestamp
        }.forEach {
            if let date = $0.value as? Date {
                dict[$0.key] = date.timeIntervalSince1970 as? Value
            } else if let date = $0.value as? Timestamp {
                dict[$0.key] = date.dateValue().timeIntervalSince1970 as? Value
            }
        }

        return try? JSONSerialization.data(withJSONObject: dict)
    }

    func toCodable<T: Codable>(of type: T.Type) -> T? {
        guard let data = toData() else { return nil }
        return try? JSONDecoder().decode(T.self, from: data)
    }
}
