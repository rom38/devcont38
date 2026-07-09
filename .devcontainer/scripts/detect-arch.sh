#!/usr/bin/env bash
case "$ARCH" in
    amd64) NVIM_ARCH="x86_64" ; GITUI_ARCH="x86_64" ; FZF_ARCH="amd64" ; FISH_ARCH="x86_64" ; EZA_ARCH="x86_64-unknown-linux-gnu" ; BROOT_ARCH="x86_64-linux" ;;
    arm64) NVIM_ARCH="arm64"   ; GITUI_ARCH="aarch64" ; FZF_ARCH="arm64" ; FISH_ARCH="aarch64" ; EZA_ARCH="aarch64-unknown-linux-gnu" ; BROOT_ARCH="aarch64-linux" ;;
    *)     echo "Unsupported arch: $ARCH"; exit 1 ;;
esac
echo "Architecture: $ARCH"
