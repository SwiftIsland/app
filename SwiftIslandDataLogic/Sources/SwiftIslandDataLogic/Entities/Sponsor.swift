//
//  File.swift
//  
//
//  Created by Niels van Hoorn on 2023-08-31.
//

import Foundation

public struct Sponsor: Decodable {
    public let title: String
    public let url: URL
    public let image: URL

    internal init(title: String, url: URL, image: URL) {
        self.title = title
        self.url = url
        self.image = image
    }

    public init() {
        self.init(title: "Example", url: URL(string: "http://example.com")!, image: URL(string: "http://example.com")!)
    }
}

extension Sponsor: Hashable, Identifiable {
    public var id: String {
        return title
    }
}

extension Sponsor {
    public static func forPreview(title: String = "", url: URL = URL(string: "http://example.com")!, image: URL = URL(string: "https://flyingmeat.com/retrobatch/images/icon-1024.png")!) -> Sponsor {
        Sponsor(
            title: title,
            url: url,
            image: image
        )
    }
}

public struct Sponsors: Decodable {
    public let apps: [Sponsor]
    public let content: [Sponsor]?
}

extension Sponsors {
    public static func forPreview(apps: [Sponsor] = [], content: [Sponsor]? = nil) -> Sponsors {
        Sponsors(
            apps: apps,
            content: content
        )
    }
}
