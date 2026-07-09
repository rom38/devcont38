#!/usr/bin/env bash
set -e
curl -fsSL "https://dystroy.org/broot/download/${BROOT_ARCH}/broot" -o /usr/local/bin/broot
chmod +x /usr/local/bin/broot
