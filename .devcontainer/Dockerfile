ARG VARIANT=trixie
FROM debian:${VARIANT}

COPY scripts/ /tmp/devcon-scripts/

RUN chmod +x /tmp/devcon-scripts/*.sh \
    && /tmp/devcon-scripts/install-apt-essentials.sh

RUN /tmp/devcon-scripts/install-apt-devtools.sh

# RUN ARCH="$(dpkg --print-architecture)" \
#     && . /tmp/devcon-scripts/detect-arch.sh \
#     && /tmp/devcon-scripts/install-neovim.sh
#
# RUN ARCH="$(dpkg --print-architecture)" \
#     && . /tmp/devcon-scripts/detect-arch.sh \
#     && /tmp/devcon-scripts/install-gitui.sh
#
# RUN ARCH="$(dpkg --print-architecture)" \
#     && . /tmp/devcon-scripts/detect-arch.sh \
#     && /tmp/devcon-scripts/install-fish.sh
#
# RUN /tmp/devcon-scripts/install-fzf.sh
#
# RUN /tmp/devcon-scripts/install-fnm-node.sh
#
# RUN /tmp/devcon-scripts/install-uv-python.sh
#
# RUN ARCH="$(dpkg --print-architecture)" \
#     && . /tmp/devcon-scripts/detect-arch.sh \
#     && /tmp/devcon-scripts/install-eza.sh
#
# RUN ARCH="$(dpkg --print-architecture)" \
#     && . /tmp/devcon-scripts/detect-arch.sh \
#     && /tmp/devcon-scripts/install-broot.sh
#
# RUN ARCH="$(dpkg --print-architecture)" /tmp/devcon-scripts/install-lf.sh
#
# RUN ARCH="$(dpkg --print-architecture)" /tmp/devcon-scripts/install-restic.sh
#
# RUN ARCH="$(dpkg --print-architecture)" /tmp/devcon-scripts/install-rclone.sh

RUN /tmp/devcon-scripts/install-bun.sh

RUN rm -rf /tmp/devcon-scripts
