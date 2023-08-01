# ``SwiftIslandDataLogic``

 This package handles the communication between the app and the firebase backend. It also provides the entities needed for the client apps to function properly.

@Metadata {
    @PageImage(
        purpose: icon, 
        source: "Logo", 
        alt: "The SwiftIsland logo.")
    @PageColor(green)
}

## Overview

The client app is required to embed the `GoogleService-Info.plist` file into their project and make sure the Firebase project is setup properly. This package might offer support
for more things that the client app is able to use, depending on the rules setup in the firebase project.

When launching the app, make sure to call the `SwiftIslandDataLogic.configure()` method. This will configure a default Firebase app.

## Topics

### Entities

- ``Activity``
