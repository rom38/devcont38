ARG VARIANT=trixie
FROM debian:${VARIANT}

COPY scripts/ /tmp/devcon-scripts/

RUN chmod +x /tmp/devcon-scripts/*.sh \
    && /tmp/devcon-scripts/install-apt-packages.sh \
    && ARCH="$(dpkg --print-architecture)" \
    && . /tmp/devcon-scripts/detect-arch.sh \
    && /tmp/devcon-scripts/install-neovim.sh \
    && /tmp/devcon-scripts/install-gitui.sh \
    && /tmp/devcon-scripts/install-fish.sh \
    && /tmp/devcon-scripts/install-fzf.sh \
    && /tmp/devcon-scripts/install-fnm-node.sh \
    && /tmp/devcon-scripts/install-uv-python.sh \
    && /tmp/devcon-scripts/install-eza.sh \
    && /tmp/devcon-scripts/install-broot.sh \
    && ARCH="$ARCH" /tmp/devcon-scripts/install-lf.sh \
    && ARCH="$ARCH" /tmp/devcon-scripts/install-restic.sh \
    && ARCH="$ARCH" /tmp/devcon-scripts/install-rclone.sh \
    && /tmp/devcon-scripts/install-bun.sh \
    && rm -rf /tmp/devcon-scripts
