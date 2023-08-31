#!/bin/sh

#  ci_post_clone.sh
#  SwiftIslandApp
#
#  Created by Paul Peelen on 2023-08-31.
#  Copyright © 2023 AppTrix AB. All rights reserved.

# Trusting plugins
# Reference: https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/7
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES
