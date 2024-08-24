//
// Created by Niels van Hoorn for the use in the Swift Island app
// Copyright © 2024 AppTrix AB. All rights reserved.
//

import SwiftUI
import ContactsUI

@objc class ContactViewControllerDelegate: NSObject, CNContactViewControllerDelegate {
    func contactViewController(_ viewController: CNContactViewController, didCompleteWith contact: CNContact?) {
        
    }
}

struct ContactViewConroller: UIViewControllerRepresentable  {
    let contact: CNContact
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = CNContactViewController(forUnknownContact: contact)
        viewController.contactStore = CNContactStore()
        viewController.allowsActions = true
        viewController.allowsEditing = true
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update the UIViewController if needed
    }
}
