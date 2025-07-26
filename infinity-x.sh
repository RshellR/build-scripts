#!/bin/bash

source /home/admin/.bashrc

cd /tmp/src/android/

set -v

# Variables
DEVICE_BRANCH=lineage-23.0
VENDOR_BRANCH=lineage-23.0
XIAOMI_BRANCH=lineage-23.0
REPO_URL="--depth=1 --no-repo-verify --git-lfs -u https://github.com/ProjectInfinity-X/manifest -b 16 -g default,-mips,-darwin,-notdefault"

