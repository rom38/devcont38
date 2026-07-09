#!/usr/bin/env bash
set -e
curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_${FZF_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
mkdir -p /usr/local/share/fish/vendor_conf.d
fzf --fish > /usr/local/share/fish/vendor_conf.d/fzf.fish
