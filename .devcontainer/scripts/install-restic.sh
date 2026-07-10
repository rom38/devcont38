#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://github.com/restic/restic/releases/download/v0.19.0/restic_0.19.0_linux_${ARCH}.bz2" \
    | bzcat > /usr/local/bin/restic
chmod +x /usr/local/bin/restic
