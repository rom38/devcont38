#!/usr/bin/env bash
# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi

if ! [ -f "$HOME/nvim-linux-arm64.deb" ]; then
	if [ -d "$HOME/neovim" ]; then
		rm -rf "$HOME/neovim"
	fi
	git clone -b stable --depth 1 https://github.com/neovim/neovim \
	&& cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo \
	&& cd build && cpack -G DEB && $SUDO dpkg -i nvim-linux-arm64.deb \
	&& cp nvim-linux-arm64.deb ~/. \
	&& cd ~ || exit
fi
