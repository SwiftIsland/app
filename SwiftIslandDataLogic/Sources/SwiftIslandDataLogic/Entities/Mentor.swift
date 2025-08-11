//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

public struct Mentor: Response {
    public let id: String
    public let biography: String
    public let imageName: String = "speaker-sofia-2025"
    public let name: String
    public let twitter: String?
    public let web: String?
    public let linkedIn: String?
    public let mastodon: String?
    public let order: Int

    public var twitterUrl: URL? {
        guard let twitter else { return nil }
        return URL(string: "https://twitter.com/\(twitter)")
    }

    public var webUrl: URL? {
        guard let web else { return nil }
        return URL(string: web)
    }

    public var linkedInUrl: URL? {
        guard let linkedIn else { return nil }
        return URL(string: "https://linkedin.com/in/\(linkedIn)")
    }

    public var mastodonUrl: URL? {
        guard let mastodon else { return nil }
        return URL(string: mastodon)
    }
}

extension Mentor: Identifiable, Hashable {
}

extension Mentor {
    public static func forPreview(id: String = "1", description: String = "Lorem ipsum dolor sit amet, **consectetur adipiscing elit**. _Proin vitae cursus_ lectus. Mauris feugiat ipsum sed vulputate gravida. Nunc a risus ac odio consequat ornare nec sit amet arcu. In laoreet elit egestas sem ornare, at maximus sem maximus. Nulla molestie suscipit mollis. Cras gravida pellentesque mattis. Etiam at nisl lorem. Nullam viverra non arcu eget elementum. Nullam a velit laoreet, luctus risus at, dapibus dolor. Aliquam nec euismod augue, id lacinia nulla.",
                                  imageName: String = ["speaker-paul-2024", "speaker-manu-2024", "speaker-malin-2024"].randomElement()!,
                                  name: String = "John Appleseed",
                                  twitter: String? = ["ppeelen", "x"].randomElement(),
                                  web: String? = "https://www.swiftisland.nl",
                                  linkedIn: String? = "ppeelen",
                                  mastodon: String? = nil,
                                  order: Int = 0) -> Mentor {
        Mentor(
            id: id,
            description: description,
            imageName: imageName,
            name: name,
            twitter: twitter,
            web: web,
            linkedIn: linkedIn,
            mastodon: mastodon,
            order: order
        )
    }
}
