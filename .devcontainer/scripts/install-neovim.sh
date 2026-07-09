#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local --strip-components=1
