//
// Created by Paul Peelen for the use in the Swift Island app
// Copyright © 2023 AppTrix AB. All rights reserved.
//

import SwiftUI
import UIKit

extension Color {
    static var background: Color {
        Color("background")
    }

    static var systemGroupedBackground: Color {
        Color(UIColor.systemGroupedBackground)
    }

    static var secondarySystemGroupedBackground: Color {
        Color(UIColor.secondarySystemGroupedBackground)
    }

    static var logoText: Color {
        Color("LogoText")
    }
    
    static var conferenceBackgroundFrom: Color {
        Color("ConferenceBackgroundFrom")
    }
    
    static var conferenceBackgroundTo: Color {
        Color("ConferenceBackgroundTo")
    }

    static var ticketText: Color {
        Color("TicketText")
    }

    static var questionMarkColor: Color {
        Color("QuestionMarkColor")
    }

    static var boxText: Color {
        Color("BoxText")
    }

    // Swift Island Logo Colors
    
    static var yellowLight: Color {
        Color("yellowLight")
    }
    
    static var yellowDark: Color {
        Color("yellowDark")
    }
    
    static var orangeLight: Color {
        Color("orangeLight")
    }
    
    static var orangeDark: Color {
        Color("orangeDark")
    }
    
    static var redLight: Color {
        Color("redLight")
    }
    
    static var redDark: Color {
        Color("redDark")
    }
}
