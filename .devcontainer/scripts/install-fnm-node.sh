#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -fsSL --retry 3 --retry-delay 5 --retry-connrefused https://fnm.vercel.app/install | bash -s -- --install-dir /usr/local/share/fnm --skip-shell
ln -s /usr/local/share/fnm/fnm /usr/local/bin/fnm
export FNM_DIR=/usr/local/share/fnm
export PATH="/usr/local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"
fnm install --lts
fnm default lts-latest
NODE_BIN=$(dirname "$(fnm exec --using=default which node)")
ln -sf "$NODE_BIN/node" /usr/local/bin/node
ln -sf "$NODE_BIN/npm" /usr/local/bin/npm
ln -sf "$NODE_BIN/npx" /usr/local/bin/npx
chmod -R a+rX /usr/local/share/fnm
