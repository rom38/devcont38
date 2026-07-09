#!/usr/bin/env bash
set -e
curl -fsSL "https://downloads.rclone.org/rclone-current-linux-${ARCH}.deb" -o /tmp/rclone.deb
dpkg -i /tmp/rclone.deb
rm /tmp/rclone.deb
