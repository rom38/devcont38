#!/usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get purge -y imagemagick imagemagick-6-common || true
apt-get install -y --no-install-recommends \
    locales build-essential \
    curl wget ca-certificates gnupg \
    tar unzip xz-utils bzip2 \
    git openssh-server jq rsync ripgrep
apt-get clean
rm -rf /var/lib/apt/lists/*
