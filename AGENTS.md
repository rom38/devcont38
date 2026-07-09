# AGENTS.md

## What this repo is

A devcontainer configuration only — no application code, no build system, no tests. The sole artifact is `.devcontainer/`.

## Container stack

- **Base**: Debian Trixie (via `FROM debian:trixie`)
- **Node.js**: v24 LTS (installed by `fnm`, symlinked to `/usr/local/bin/node`)
- **Python**: 3.14 (installed by `uv`, symlinked to `/usr/local/bin/python`)

## Tools installed by feature (devcontainer.json)

- `common-utils` (zsh, vscode user)
- `gh` (latest), `fd`

## Tools installed by Dockerfile (prebuilt binaries)

- **neovim** — stable release from GitHub
- **gitui** — latest release from GitHub (`/releases/latest/download/` redirect)
- **fzf** — v0.73.1 from GitHub (version hardcoded in Dockerfile, update manually)
- **fish** — 4.7.1 from GitHub (version hardcoded in Dockerfile, update manually)
- **bun** — latest (installed via `bun.sh/install` with `BUN_INSTALL=/usr/local`)
- **broot** — v1.57.0 from dystroy.org (version hardcoded, update manually)
- **eza** — latest release from GitHub (`/releases/latest/download/` redirect)
- **lf** — latest release from GitHub (`/releases/latest/download/` redirect)
- **restic** — v0.19.0 from GitHub (version hardcoded in Dockerfile, update manually)
- **rclone** — latest release from downloads.rclone.org (`rclone-current-linux-*.deb`)

## Dockerfile structure

`COPY scripts/` copies all scripts into `/tmp/devcon-scripts/`, then a single `RUN` chains them:

1. `install-apt-packages.sh` — imagemagick purge + ~40 dev packages (build-essential, libs, ncdu, tree, tmux, bat, mc, htop, lf, jq, iputils-ping, etc.) + openssh-server + subversion from apt + apt cleanup
2. `detect-arch.sh` (sourced) + 12 `install-*.sh` — neovim, gitui, fzf, fish, fnm+Node.js LTS, uv+Python 3.14, eza, broot, lf, restic, rclone, bun

Scripts are in `.devcontainer/scripts/`. Hardcoded versions (update in the scripts, not the Dockerfile):
- fzf v0.73.1 in `install-fzf.sh`
- fish 4.7.1 in `install-fish.sh`
- restic v0.19.0 in `install-restic.sh`
- broot v1.57.0 in `install-broot.sh`

`install-subversion.sh` is a standalone script — NOT used by the Dockerfile build chain (subversion is installed from apt in `install-apt-packages.sh`). It exists for manual Subversion 1.14.5 source builds.

## Key facts

- `postCreateCommand` globally installs `@kilocode/cli` via npm, creates fish conf.d for `~/.local/bin` PATH
- Remote user is `vscode` (uid 1000, gid 1000)
- Python interpreter path for VS Code: `/usr/local/bin/python`
- Default shell is bash with fish auto-launched for interactive sessions (preserves DevPod SSH compatibility)
- `FNM_DIR=/usr/local/share/fnm` set via `containerEnv` (also exported during Dockerfile build)
- `devcon-doc.md`, `docker-file.md`, `fnm-doc.md`, and `devpod-doc.md` are reference documentation — don't treat as project code or config
- No lint, typecheck, or test commands exist

## Root-level setup-*.sh scripts

Standalone manual setup scripts — NOT executed by the devcontainer. `setup_python.sh` and `setup-gh.sh` are redundant (covered by features). `setup-debian.sh`, `setup-nvim.sh`, `setup-gitui.sh`, and `setup-fish.sh` equivalents are merged into the Dockerfile.
