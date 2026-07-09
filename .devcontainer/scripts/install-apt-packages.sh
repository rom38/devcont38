#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get purge -y imagemagick imagemagick-6-common
apt-get install -y --no-install-recommends \
    locales build-essential \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev gnupg lzip tar unzip \
    gawk gettext gperf m4 ed fig2dev \
    lua5.3 libc-ares-dev libicu-dev openssl luajit bc rsync wget \
    ncdu tree tmux bat mc htop ninja-build cmake jq iputils-ping \
    ca-certificates sysbench sqlite3 git subversion bzip2 openssh-server ripgrep
apt-get clean
rm -rf /var/lib/apt/lists/*
