<p align="center">
    <img src ="Logo.png" alt="Swift Island Logo" title="Swift Island 2023" width=200 />
</p>

<p align="center">
	<img alt="App Store" src="https://img.shields.io/itunes/v/1468876096?label=App%20Store">
    <img src="https://img.shields.io/badge/platform-SwiftUI-blue.svg" alt="Swift UI" title="Swift UI" />
    <br/>
    <a href="https://twitter.com/swiftislandnl">
        <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/swiftislandnl?label=SwiftIsland" alt="Twitter: @swiftislandnl" title="Twitter: @swiftislandnl">
    </a>
    </a>
    <a href="https://mastodon.nu/@ppeelen">
<img alt="Mastodon Follow" src="https://img.shields.io/mastodon/follow/109416415024329828?domain=https%3A%2F%2Fmastodon.nu&style=social&label=Mastodon%3A%20%40peelen">
    </a>
    <a href="https://twitter.com/ppeelen">
        <img alt="Twitter Follow" src="https://img.shields.io/twitter/follow/swiftislandnl?label=PPeelen" alt="Twitter: @ppeelen" title="Twitter: @ppeelen">
    </a>
</p>

# Swift Island App
This is the official Swift Island 2023 iOS app. 

## Prerequisites
In order to build and run this app, you will need access to the Firebase project for Swift Island, since this app uses the data from said firestore database.

The project is build for Xcode 14 and upwards and the minimal deployment target is iOS 16 for now.

## Setup
### Tickets
If you wish to access ticket functionality you need to have a Tito token. This token should be stored inside `/SwiftIslandApp/Resources/Secrets.json`. This file is ignored and should not be pushed to the repo. The contents of the file should be as follows:
```json
{
    "CHECKIN_LIST_SLUG": "<# TITO SLUG #>"
}
```

## Author
This app is mainly build by [Paul Peelen](https://paulpeelen.com) [[Github](https://github.com/ppeelen)] [[Twitter](https://twitter.com/ppeelen)], for use for Swift Island 2023.

## Code Style
This project applies [_The Official Kodeco Swift Style Guide_](https://github.com/kodecocodes/swift-style-guide) (formally known as Ray Wenderlich Swift Style Guide), with a few exceptions which are mentioned below.
This project uses [SwiftLint](https://github.com/realm/SwiftLint) to enforce the code style. PR's with violations of the SwiftLint rules will not be approved.

### Exceptions

#### `line_limit`
The line limit is changed from 120 to 200 for warnings and 300 for errors. The only exception where `line_limit` may be disabled is in use with long texts. Prefered is to line break these and join, but in this case it is ok to disable.

#### `indentation_width`
The `indentation_width` for this project is `4` instead of `2`.

#### `force_unwrapping`
Force unwrapping is discouraged, with two exceptions:
##### Exception 1
When creating an `URL` from `String` and the string is in human readable format inside the code. Example:
```
let url = URL(string: "https://swiftisland.nl")! // swiftlint:disable:this force_unwrap
```
Any creation of dynamic `URL` may not disable this rule. This may only be disabled on line level, meaning using `:this` format.

##### Exception 2
Use in Preview code. When creating a preview for a SwiftUI view, at times mock code is used. It is OK to force_unwrap, but prefered not to do so if possible.

Example:
```
// swiftlint:disable force_unwrapping
let selectedDate = Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 4, hour: 9))!
let secondDate = Calendar.current.date(from: DateComponents(year: 2023, month: 9, day: 4, hour: 10))!
// swiftlint:enable force_unwrapping
```

Here it is allowed to force_unwrap using disable/enable block or on line level using `:this`.

## License
This project is released under the [GPL-3.0 license](https://github.com/SwiftIsland/app/blob/main/LICENSE). 