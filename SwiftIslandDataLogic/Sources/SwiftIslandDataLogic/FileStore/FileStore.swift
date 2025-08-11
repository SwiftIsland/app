//
//  FileStore.swift
//  SwiftIslandDataLogic
//
//  Created by Niels van Hoorn on 2025-08-11.
//

import Foundation

enum Conf {
    static let org = "SwiftIsland"     // fill
    static let repo = "app"   // fill
}


// MARK: - ETag + Net

final class ETagStore {
    static let shared = ETagStore()
    private let d = UserDefaults.standard
    func get(_ url: URL) -> String? { d.string(forKey: "eetag::" + url.absoluteString) }
    func set(_ v: String?, _ url: URL) { let k = "eetag::" + url.absoluteString; v == nil ? d.removeObject(forKey: k) : d.set(v, forKey: k) }
}

enum Net {
    static func getWithETag(_ url: URL, etag: String?) async throws -> (code: Int, data: Data?, etag: String?) {
        var req = URLRequest(url: url)
//        req.setValue("gzip", forHTTPHeaderField: "Accept-Encoding")
        if let etag { req.setValue(etag, forHTTPHeaderField: "If-None-Match") }
        let (data, resp) = try await URLSession.shared.data(for: req)
        guard let http = resp as? HTTPURLResponse else { throw URLError(.badServerResponse) }
        return (http.statusCode, data, http.value(forHTTPHeaderField: "ETag"))
    }
}

// MARK: - File store (atomic)

struct FileStore {
    static let base: URL = {
        let dir = try! FileManager.default.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let folder = dir.appendingPathComponent("DataCache", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }()
    static func writeAtomic(_ data: Data, to url: URL) throws {
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        let tmp = url.appendingPathExtension("tmp")
        try data.write(to: tmp, options: .atomic)
        if FileManager.default.fileExists(atPath: url.path) {
            _ = try FileManager.default.replaceItemAt(url, withItemAt: tmp)
        } else {
            try FileManager.default.moveItem(at: tmp, to: url)
        }
    }
    
    static func read(from url: URL) throws -> Data {
        return try Data(contentsOf: url)
    }
}

// MARK: - Sync

final class DataSync {
    
    static func fetchURL(_ path: String) async throws -> Data {
        let url = try fileURL(for: path)
        let etag0 = ETagStore.shared.get(url)
        let res = try await Net.getWithETag(url, etag: etag0)
        let storeURL = FileStore.base.appendingPathComponent(path)
        guard res.code != 304 else {
            return try FileStore.read(from: storeURL)
        }
        guard let body = res.data else { throw URLError(.badURL) }
        try FileStore.writeAtomic(body, to: storeURL)
        if let e = res.etag { ETagStore.shared.set(e, url) }
        return body
    }

    
    private static func fileURL(for path: String) throws -> URL {
        let s = "https://raw.githubusercontent.com/\(Conf.org)/\(Conf.repo)/refs/heads/main/\(path)"
        guard let u = URL(string: s) else { throw URLError(.badURL) }
        return u
    }

}
