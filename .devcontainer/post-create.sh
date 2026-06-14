#!/usr/bin/env bash
set -e

# Fish autostart for interactive bash sessions (preserves DevPod SSH compatibility)
if ! grep -q '/usr/local/bin/fish' /home/vscode/.bashrc 2>/dev/null; then
    printf '\n# Launch fish for interactive shells\nif [ -z "$FISH_SKIP" ] && [ -t 0 ] && [ -x /usr/local/bin/fish ]; then\n    exec /usr/local/bin/fish\nfi\n' >> /home/vscode/.bashrc
fi

mkdir -p /home/vscode/.config/fish/conf.d
printf 'fish_add_path %s\n' /home/vscode/.local/bin > /home/vscode/.config/fish/conf.d/localbin.fish

npm config set prefix /home/vscode/.local
npm i -g @kilocode/cli firecrawl-mcp @modelcontextprotocol/server-sequential-thinking neovim
sudo uv pip install --system pynvim

# NvChad (neovim config)
git clone https://github.com/NvChad/starter /home/vscode/.config/nvim 2>/dev/null || true
# Note: run :Lazy sync and :MasonInstallAll inside nvim on first use
