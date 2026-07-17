ARG VARIANT=trixie
# FROM debian:${VARIANT}
FROM buildpack-deps:${VARIANT}

COPY scripts/ /tmp/devcon-scripts/

RUN chmod +x /tmp/devcon-scripts/*.sh \
    && /tmp/devcon-scripts/install-apt-essentials.sh

RUN /tmp/devcon-scripts/install-apt-devtools.sh

RUN /tmp/devcon-scripts/install-binaries.sh

RUN rm -rf /tmp/devcon-scripts
