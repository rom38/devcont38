ARG VARIANT=trixie
FROM debian:${VARIANT}

RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get purge -y imagemagick imagemagick-6-common \
    && apt-get install -y --no-install-recommends \
        locales build-essential \
        libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
        curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
        libffi-dev liblzma-dev gnupg lzip tar unzip \
        gawk gettext gperf m4 ed fig2dev \
        lua5.3 libc-ares-dev libicu-dev openssl luajit bc rsync wget \
        ncdu tree tmux bat mc htop ninja-build cmake lf jq \
        ca-certificates sysbench sqlite3 git subversion \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN ARCH=$(dpkg --print-architecture) \
    && case "$ARCH" in \
        amd64) NVIM_ARCH="x86_64" ; GITUI_ARCH="x86_64" ; FZF_ARCH="amd64" ; FISH_ARCH="x86_64" ;; \
        arm64) NVIM_ARCH="arm64"   ; GITUI_ARCH="aarch64" ; FZF_ARCH="arm64" ; FISH_ARCH="aarch64" ;; \
        *)     echo "Unsupported arch: $ARCH"; exit 1 ;; \
       esac \
    && echo "Architecture: $ARCH" \
    && curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${NVIM_ARCH}.tar.gz" \
        | tar xzf - -C /usr/local --strip-components=1 \
    && curl -fsSL "https://github.com/gitui-org/gitui/releases/latest/download/gitui-linux-${GITUI_ARCH}.tar.gz" \
        | tar xzf - -C /usr/local/bin \
    && curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.73.1/fzf-0.73.1-linux_${FZF_ARCH}.tar.gz" \
        | tar xzf - -C /usr/local/bin \
    && mkdir -p /usr/local/share/fish/vendor_conf.d \
    && fzf --fish > /usr/local/share/fish/vendor_conf.d/fzf.fish \
    && curl -fsSL "https://github.com/fish-shell/fish-shell/releases/download/4.7.1/fish-4.7.1-linux-${FISH_ARCH}.tar.xz" \
        | tar xJf - -C /usr/local/bin \
    && echo /usr/local/bin/fish >> /etc/shells \
    && curl -fsSL https://fnm.vercel.app/install | bash -s -- --install-dir /usr/local/share/fnm --skip-shell \
    && ln -s /usr/local/share/fnm/fnm /usr/local/bin/fnm \
    && export FNM_DIR=/usr/local/share/fnm PATH="/usr/local/share/fnm:$PATH" \
    && eval "$(fnm env --shell bash)" \
    && fnm install --lts \
    && fnm default lts-latest \
    && NODE_BIN=$(dirname "$(fnm exec --using=default which node)") \
    && ln -sf "$NODE_BIN/node" /usr/local/bin/node \
    && ln -sf "$NODE_BIN/npm" /usr/local/bin/npm \
    && ln -sf "$NODE_BIN/npx" /usr/local/bin/npx \
    && chmod -R a+rX /usr/local/share/fnm \
    && curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh \
    && UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python install 3.14 \
    && ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python3 \
    && ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python \
    && curl -fsSL https://bun.sh/install | env BUN_INSTALL=/usr/local bash
