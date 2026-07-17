#!/usr/bin/env bash
set -e

# Fish autostart for interactive bash sessions (preserves DevPod SSH compatibility)
if ! grep -q '/usr/local/bin/fish' /home/vscode/.bashrc 2>/dev/null; then
    printf '\n# Launch fish for interactive shells\nif [ -z "$FISH_SKIP" ] && [ -t 0 ] && [ -x /usr/local/bin/fish ]; then\n    exec /usr/local/bin/fish\nfi\n' >> /home/vscode/.bashrc
fi

mkdir -p /home/vscode/.config/fish/conf.d
printf 'fish_add_path %s\n' /home/vscode/.local/bin > /home/vscode/.config/fish/conf.d/localbin.fish

npm config set prefix /home/vscode/.local
# npm i -g @kilocode/cli firecrawl-mcp @modelcontextprotocol/server-sequential-thinking neovim
npm i -g neovim
bun add -g @kilocode/cli firecrawl-mcp @modelcontextprotocol/server-sequential-thinking
printf 'fish_add_path %s\n' $HOME/.bun/bin > /home/vscode/.config/fish/conf.d/localbunbin.fish

# sudo uv pip install --system pynvim
uv tool install pynvim

# NvChad — Neovim configuration framework
if [ ! -d /home/vscode/.config/nvim ]; then
    git clone https://github.com/rom38/nvchd_cfg /home/vscode/.config/nvim --depth 1
    # nvim --headless "+Lazy! sync" +qa || true
    # nvim --headless "+Lazy! clean nvim-treesitter" +qa  || true
    # nvim --headless "+Lazy! install nvim-treesitter" +qa || true
    nvim --headless "+Lazy! sync" "+MasonInstallAll" "+TSUpdateSync" +qa || true
fi
