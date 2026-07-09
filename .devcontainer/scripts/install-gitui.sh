#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/gitui-org/gitui/releases/latest/download/gitui-linux-${GITUI_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
