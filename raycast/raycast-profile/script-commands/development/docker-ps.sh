#!/bin/bash
# @raycast.title Docker PS
# @raycast.mode fullOutput
# @raycast.icon docker
# @raycast.packageName Development

docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
