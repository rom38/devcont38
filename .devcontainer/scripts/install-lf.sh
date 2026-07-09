#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/gokcehan/lf/releases/latest/download/lf-linux-${ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
