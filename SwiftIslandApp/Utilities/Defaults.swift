//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import Defaults
import SwiftIslandDataLogic

extension Defaults.Keys {
    static let isPacklistSetupFor2024 = Key<Bool>("isPacklistSetupFor2024", default: false)
    static let userIsActivated = Key<Bool>("userActivated2024", default: false)
    static let packingItems = Key<[PackingItem]>("packingList", default: [])
    static let hasShownTicketReminder = Key<Bool>("hasShownTicketReminder", default: false)
}
