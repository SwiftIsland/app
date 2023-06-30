import Foundation

protocol Response: Codable { }

//struct EmptyResponse: Response {
//    init() {}
//}

extension String: Response { }
