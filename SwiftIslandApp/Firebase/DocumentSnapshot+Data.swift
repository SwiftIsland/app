import FirebaseFirestore

extension DocumentSnapshot {
    func data<T: Codable>(as: T.Type) -> T? {
        data()?.toCodable(of: T.self)
    }

}
