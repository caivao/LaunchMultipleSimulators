#!/bin/sh

#  RunSimulators.sh
#  LaunchMultipleSimulators
#
#  Created by lifeng on 2019/3/29.
#  Copyright © 2019 Done. All rights reserved.

simulator=$1
app_path=$2
bundle_identifier=$3

xcrun instruments -w ${simulator}
xcrun simctl install ${simulator} ${app_path}
xcrun simctl launch  ${simulator} ${bundle_identifier}
