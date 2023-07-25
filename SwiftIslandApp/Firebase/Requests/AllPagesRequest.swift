//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

struct AllPagesRequest: Request {
    typealias Output = Page

    var path = "pages"
}
