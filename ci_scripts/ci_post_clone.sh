#!/bin/zsh

#  ci_post_clone.sh
#  SwiftIslandApp
#
#  Created by Paul Peelen on 2023-08-31.
#  Copyright © 2023 AppTrix AB. All rights reserved.

# Trusting plugins
# Reference: https://forums.swift.org/t/telling-xcode-14-beta-4-to-trust-build-tool-plugins-programatically/59305/7
defaults write com.apple.dt.Xcode IDESkipPackagePluginFingerprintValidatation -bool YES

# Flag to track if any required environment variables are missing
missing_variables=false

# Ensure required environment variables are set
if [[ -z "$CI_XCODEBUILD_ACTION" ]]; then
    echo "CI_XCODEBUILD_ACTION is not set."
    missing_variables=true
fi

if [[ -z "$CI_PRIMARY_REPOSITORY_PATH" ]]; then
    echo "CI_PRIMARY_REPOSITORY_PATH is not set."
    missing_variables=true
fi

if [[ -z "$CHECKIN_LIST_SLUG" ]]; then
    echo "CHECKIN_LIST_SLUG is not set."
    missing_variables=true
fi

# Exit if any required environment variables are missing
if $missing_variables; then
    echo "One or more required environment variables are missing. Exiting."
    exit 1
fi

SECRETS_PATH="$CI_PRIMARY_REPOSITORY_PATH/SwiftIslandApp/Resources/Secrets.json"

# Create or overwrite the Secrets.json file with the provided content
printf "{\"CHECKIN_LIST_SLUG\":\"%s\"}" "$CHECKIN_LIST_SLUG" > $SECRETS_PATH

echo "Wrote Secrets.json file at $SECRETS_PATH."

exit 0
