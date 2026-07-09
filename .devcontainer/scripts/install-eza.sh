#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
