#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://downloads.rclone.org/rclone-current-linux-${ARCH}.deb" -o /tmp/rclone.deb
dpkg -i /tmp/rclone.deb
rm /tmp/rclone.deb
