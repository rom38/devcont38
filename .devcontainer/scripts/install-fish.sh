#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
mkdir -p /usr/local/share/fish/vendor_conf.d
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused "https://github.com/fish-shell/fish-shell/releases/download/4.7.1/fish-4.7.1-linux-${FISH_ARCH}.tar.xz" \
    | tar xJf - -C /usr/local/bin
echo /usr/local/bin/fish >> /etc/shells
