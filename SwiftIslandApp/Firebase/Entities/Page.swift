//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct Page: Response {
    let id: String
    let title: String
    let content: String
    let imageName: String
}

extension Page: Identifiable { }

extension Page {
    static func forPreview(id: String = "1",
                           title: String = "Title",
                           content: String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec ut sapien sed leo hendrerit pellentesque. Praesent at malesuada ex. Praesent accumsan est vitae libero mattis, non interdum mi lobortis. Vestibulum scelerisque, arcu nec convallis commodo, augue velit semper enim, eu maximus augue urna a eros. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; In auctor vitae metus condimentum fringilla. Nunc dapibus eleifend augue, aliquam consectetur tortor condimentum eget. Etiam ut aliquet odio, non suscipit felis. Sed sed massa nec dolor iaculis cursus. Phasellus nec volutpat ante, ac tempus urna. Integer gravida justo libero, nec rutrum ligula porta ut. Sed a tristique quam, ac malesuada justo.",
                           imageName: String = "") -> Page {
        Page(id: id, title: title, content: content, imageName: imageName)
    }
}
