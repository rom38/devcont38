#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://github.com/gokcehan/lf/releases/latest/download/lf-linux-${ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
