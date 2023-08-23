#!/bin/sh

#  Created by Paul Peelen on 2023-08-23.
#  Copyright © 2023 AppTrix AB. All rights reserved.

#  Reference: https://stackoverflow.com/a/75225641/406677

# Move to the place where the scripts are located.
cd $CI_WORKSPACE/ci_scripts || exit 1

printf "{\"CHECKIN_LIST_SLUG\":\"%s\"}" "$CHECKIN_LIST_SLUG" >> ${SOURCE_ROOT}/SwiftIslandApp/Resources/Secrets.json

echo "Wrote Secrets.json file."

exit 0
