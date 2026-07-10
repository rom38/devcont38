#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
