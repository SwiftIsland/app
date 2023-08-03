//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation
import Defaults

public struct PackingItem: Response {
    public let id: String
    public let title: String
    public let subTitle: String
    public var checked: Bool
    public let order: Int
}

extension PackingItem: Identifiable { }

extension PackingItem {
    static func forPreview(id: String = "1", title: String = "Foo bar", subTitle: String = "Lorum Ipsum", checked: Bool = false, order: Int = 0) -> PackingItem {
        PackingItem(id: id, title: title, subTitle: subTitle, checked: checked, order: order)
    }
}

extension PackingItem: Defaults.Serializable { }
