#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \
    libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev \
    libncursesw5-dev tk-dev libxml2-dev libxmlsec1-dev \
    libffi-dev liblzma-dev lzip \
    gawk gettext gperf m4 ed fig2dev \
    lua5.3 libc-ares-dev libicu-dev openssl luajit bc \
    ncdu tree tmux bat mc htop ninja-build cmake \
    sysbench sqlite3 subversion iputils-ping
apt-get clean
rm -rf /var/lib/apt/lists/*
