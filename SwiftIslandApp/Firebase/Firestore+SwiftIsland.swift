import FirebaseCore
import FirebaseFirestore

extension Firestore {
    static var db = Firestore.firestore()

    static func get<R: Request>(request: R) async throws -> [R.Output] {
        guard let limit = request.limit else {
            return try await self.get(request.path)
        }

        return try await db.collection(request.path)
            .limit(to: limit)
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
