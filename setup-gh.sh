#!/usr/bin/env bash
# Do not require sudo if already running as root.
if [ "$(id -u)" = "0" ]; then
	SUDO=""
else
	SUDO="sudo"
fi

curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
 | $SUDO dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
 && $SUDO chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
 && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
 | $SUDO tee /etc/apt/sources.list.d/github-cli.list > /dev/null && $SUDO apt update && $SUDO apt install gh -y
