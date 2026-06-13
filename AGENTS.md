# AGENTS.md

## What this repo is

A devcontainer configuration only — no application code, no build system, no tests. The sole artifact is `.devcontainer/`.

## Container stack

- **Base**: Debian Trixie (via `FROM debian:trixie`)
- **Node.js**: v24 LTS (installed by `fnm`, symlinked to `/usr/local/bin/node`)
- **Python**: 3.14 (installed by `uv`, symlinked to `/usr/local/bin/python`)

## Tools installed by feature (devcontainer.json)

- `common-utils` (zsh, vscode user)
- `bun` — latest (ghcr.io/devcontainer-community)
- `gh` (latest), `fd`

## Tools installed by Dockerfile (prebuilt binaries)

- **neovim** — stable release from GitHub
- **gitui** — latest release from GitHub (`/releases/latest/download/` redirect)
- **fzf** — v0.73.1 from GitHub (version hardcoded in Dockerfile, update manually)
- **fish** — 4.7.1 from GitHub (version hardcoded in Dockerfile, update manually)

## Dockerfile layers (2 total)

1. `RUN apt` — imagemagick purge + ~40 dev packages (build-essential, libs, ncdu, tree, tmux, bat, mc, htop, lf, jq, etc.) + subversion from apt + apt cleanup
2. `RUN binaries` — neovim + gitui + fzf + fish (all arch-conditional) + fnm + Node.js LTS + uv + Python 3.14

## Key facts

- `postCreateCommand` globally installs `@kilocode/cli` via npm, creates fish conf.d for `~/.local/bin` PATH
- Remote user is `vscode` (uid 1000, gid 1000)
- Python interpreter path for VS Code: `/usr/local/bin/python`
- Default shell is fish (`$SHELL=/usr/local/bin/fish`, `chsh -s /usr/local/bin/fish vscode`)
- `FNM_DIR=/usr/local/share/fnm` set via `containerEnv` (also exported during Dockerfile build)
- `devcon-doc.md`, `docker-file.md`, and `fnm-doc.md` are reference documentation — don't treat as project code or config
- No lint, typecheck, or test commands exist

## Root-level setup-*.sh scripts

Standalone manual setup scripts — NOT executed by the devcontainer. `setup_python.sh` and `setup-gh.sh` are redundant (covered by features). `setup-debian.sh`, `setup-nvim.sh`, `setup-gitui.sh`, and `setup-fish.sh` equivalents are merged into the Dockerfile.
