import Foundation

protocol Request {
    associatedtype Output: Response

    var path: String { get set }
    var output: Output? { get }
    var limit: Int? { get }
    var queryPredicate: NSPredicate? { get }
    var updatedDataFields: Codable? { get }
}

// Setup default values
extension Request {
    var output: Output? { nil }
    var limit: Int? { nil }
    var queryPredicate: NSPredicate? { nil }
    var updatedDataFields: Codable? { nil }
}
