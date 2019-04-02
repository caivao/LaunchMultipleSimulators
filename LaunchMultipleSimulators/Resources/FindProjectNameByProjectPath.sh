#!/bin/sh

#  FindAppProjectName.sh
#  LaunchMultipleSimulators
#
#  Created by lifeng on 2019/3/31.
#  Copyright © 2019 Done. All rights reserved.

project_path=$1
path=$(find ${project_path}/*xcodeproj | head -n 1)
app_path=${path##*/}
app_name=${app_path%.*}
echo ${app_name}

