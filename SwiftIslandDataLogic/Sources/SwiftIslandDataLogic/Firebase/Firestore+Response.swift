import Foundation

public protocol Response: Codable { }

extension String: Response { }
