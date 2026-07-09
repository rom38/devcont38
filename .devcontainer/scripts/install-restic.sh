#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/restic/restic/releases/download/v0.19.0/restic_0.19.0_linux_${ARCH}.bz2" \
    | bzcat > /usr/local/bin/restic
chmod +x /usr/local/bin/restic
