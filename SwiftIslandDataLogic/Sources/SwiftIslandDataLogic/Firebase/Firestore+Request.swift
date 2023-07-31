import Foundation

public protocol Request {
    associatedtype Output: Response

    var path: String { get set }
    var output: Output? { get }
    var queryPredicate: NSPredicate? { get }
    var updatedDataFields: Codable? { get }
}

// Setup default values
public extension Request {
    var output: Output? { nil }
    var queryPredicate: NSPredicate? { nil }
    var updatedDataFields: Codable? { nil }
}
