//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import Defaults

struct PackingItem: Response {
    let id: String
    let title: String
    let subTitle: String
    var checked: Bool
}

extension PackingItem: Identifiable { }

extension PackingItem {
    static func forPreview(id: String = "1", title: String = "Foo bar", subTitle: String = "Lorum Ipsum", checked: Bool = false) -> PackingItem {
        PackingItem(id: id, title: title, subTitle: subTitle, checked: checked)
    }
}

extension PackingItem: Defaults.Serializable { }
