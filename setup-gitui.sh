#!/usr/bin/env bash
# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi

ARCHITECTURE=$(dpkg --print-architecture)
if [ "$ARCHITECTURE" = "amd64" ]; then
	ARCHITECTURE="musl"
fi
if [ "$ARCHITECTURE" = "arm64" ]; then
	ARCHITECTURE="aarch64"
fi
# echo $ARCHITECTURE
# echo "https.*gitui.*linux.*${ARCHITECTURE}.*gz"
# echo "111"; \
curl https://api.github.com/repos/extrawurst/gitui/releases/latest \
| grep -wo "https.*gitui.*linux.*${ARCHITECTURE}.*gz" \
| wget -i -
find . -maxdepth 1 -name "gitui*linux*${ARCHITECTURE}*gz" -exec tar xzvf {} \;; 
$SUDO chown root:root gitui
$SUDO chmod u=rwx,g=rx,o=rx gitui
$SUDO mv gitui /usr/local/bin/ 
# find . -maxdepth 1 -name "gitui*linux*${ARCHITECTURE}*gz" -exec rm {} \;;  

