import FirebaseCore
import FirebaseFirestore

extension Firestore {
    static var db = Firestore.firestore()

    static func get<R: Request>(request: R) async throws -> [R.Output] {
        var query: Query = db.collection(request.path)

        if let predicate = request.queryPredicate {
            debugPrint("Using predicate!")
            query = query.filter(using: predicate)
        }

        return try await query
            .getDocuments()
            .documents
            .compactMap { $0.data(as: R.Output.self) }
    }

    static func get<T: Codable>(_ path: String) async throws -> [T] {
        try await db.collection(path)
            .getDocuments()
            .documents
            .compactMap { $0.data(as: T.self) }
    }

    static func update<R: Request>(request: R) async throws {
        try await update(
            data: request.updatedDataFields?.dictionary ?? [:],
            path: request.path
        )
    }

    static func update(data: [AnyHashable: Any], path: String) async throws {
        try await db.document(path).updateData(data)
    }
}
