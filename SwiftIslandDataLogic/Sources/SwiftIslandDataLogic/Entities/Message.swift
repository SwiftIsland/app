//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Foundation

public struct Message: Response {
    public let id: String
    public let title: String
    public let body: String
    public let icon: String
    public let push: Bool
    public let date: Date
    public let link: URL?
    public let location: String?
}

extension Message: Identifiable { }
