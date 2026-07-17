#!/usr/bin/env bash
set -e
ARCH=$(dpkg --print-architecture)
case "$ARCH" in
    amd64) NVIM_ARCH="x86_64" ; GITUI_ARCH="x86_64" ; FZF_ARCH="amd64" ; FISH_ARCH="x86_64" ; EZA_ARCH="x86_64-unknown-linux-gnu" ; BROOT_ARCH="x86_64-linux" ;;
    arm64) NVIM_ARCH="arm64"   ; GITUI_ARCH="aarch64" ; FZF_ARCH="arm64" ; FISH_ARCH="aarch64" ; EZA_ARCH="aarch64-unknown-linux-gnu" ; BROOT_ARCH="aarch64-linux" ;;
    *)     echo "Unsupported arch: $ARCH"; exit 1 ;;
esac
echo "Architecture: $ARCH"

curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local --strip-components=1

curl -fsSL "https://github.com/gitui-org/gitui/releases/latest/download/gitui-linux-${GITUI_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin

curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_${FZF_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin
mkdir -p /usr/local/share/fish/vendor_conf.d
fzf --fish > /usr/local/share/fish/vendor_conf.d/fzf.fish

curl -fsSL "https://github.com/fish-shell/fish-shell/releases/download/4.7.1/fish-4.7.1-linux-${FISH_ARCH}.tar.xz" \
    | tar xJf - -C /usr/local/bin
echo /usr/local/bin/fish >> /etc/shells

curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir /usr/local/share/fnm --skip-shell
ln -s /usr/local/share/fnm/fnm /usr/local/bin/fnm
export FNM_DIR=/usr/local/share/fnm PATH="/usr/local/share/fnm:$PATH"
eval "$(fnm env --shell bash)"
fnm install --lts
fnm default lts-latest
NODE_BIN=$(dirname "$(fnm exec --using=default which node)")
ln -sf "$NODE_BIN/node" /usr/local/bin/node
ln -sf "$NODE_BIN/npm" /usr/local/bin/npm
ln -sf "$NODE_BIN/npx" /usr/local/bin/npx
chmod -R a+rX /usr/local/share/fnm

curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh
# UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python install 3.14
# ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python3
# ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python

curl -fsSL "https://github.com/eza-community/eza/releases/latest/download/eza_${EZA_ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin

curl -fsSL "https://dystroy.org/broot/download/${BROOT_ARCH}/broot" -o /usr/local/bin/broot
chmod +x /usr/local/bin/broot

curl -fsSL "https://github.com/gokcehan/lf/releases/latest/download/lf-linux-${ARCH}.tar.gz" \
    | tar xzf - -C /usr/local/bin

curl -fsSL "https://github.com/restic/restic/releases/download/v0.19.0/restic_0.19.0_linux_${ARCH}.bz2" \
    | bzcat > /usr/local/bin/restic
chmod +x /usr/local/bin/restic

curl -fsSL "https://downloads.rclone.org/rclone-current-linux-${ARCH}.deb" -o /tmp/rclone.deb
dpkg -i /tmp/rclone.deb
rm /tmp/rclone.deb

curl -fsSL https://bun.sh/install | env BUN_INSTALL=/usr/local bash