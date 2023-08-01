//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

public struct Mentor: Response {
    public let description: String
    public let imageName: String
    public let name: String
    public let twitter: URL?
    public let web: URL?
    public let linkedIn: URL?
    public let order: Int
}

extension Mentor: Identifiable {
    public var id: String { name }
}

extension Mentor {
    public static func forPreview(description: String = "Lorem ipsum dolor sit amet, **consectetur adipiscing elit**. _Proin vitae cursus_ lectus. Mauris feugiat ipsum sed vulputate gravida. Nunc a risus ac odio consequat ornare nec sit amet arcu. In laoreet elit egestas sem ornare, at maximus sem maximus. Nulla molestie suscipit mollis. Cras gravida pellentesque mattis. Etiam at nisl lorem. Nullam viverra non arcu eget elementum. Nullam a velit laoreet, luctus risus at, dapibus dolor. Aliquam nec euismod augue, id lacinia nulla.",
                           imageName: String = ["JordiBruin", "AndreyVolodin", "MaximCramer"].randomElement()!,
                           name: String = "John Appleseed",
                           twitter: URL? = nil,
                           web: URL? = nil,
                           linkedIn: URL? = nil,
                           order: Int = 0) -> Mentor {
        Mentor(
            description: description,
            imageName: imageName,
            name: name,
            twitter: twitter,
            web: web,
            linkedIn: linkedIn,
            order: order
        )
    }
}
