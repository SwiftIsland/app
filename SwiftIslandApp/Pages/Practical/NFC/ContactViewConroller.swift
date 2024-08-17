//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import ContactsUI

struct ContactViewConroller: UIViewControllerRepresentable {
    let contact: CNContact
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CNContactViewController(forNewContact: contact)
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the UIViewController if needed
    }
}
