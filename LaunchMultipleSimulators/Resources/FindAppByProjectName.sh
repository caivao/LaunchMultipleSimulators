#!/bin/sh

#  FindAppByProjectName.sh
#  LaunchMultipleSimulators
#
#  Created by lifeng on 2019/3/31.
#  Copyright © 2019 Done. All rights reserved.

project_name=$1
app_name=$2

path=$(find ~/Library/Developer/Xcode/DerivedData/${project_name}-*/Build/Products/*-* -name "${app_name}.app")
echo ${path}
