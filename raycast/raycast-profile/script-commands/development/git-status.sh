#!/bin/bash
# @raycast.title Git Status
# @raycast.mode fullOutput
# @raycast.icon git-branch
# @raycast.packageName Development

cd "$(pwd)" && git status --porcelain
