#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://dystroy.org/broot/download/${BROOT_ARCH}/broot" -o /usr/local/bin/broot
chmod +x /usr/local/bin/broot
