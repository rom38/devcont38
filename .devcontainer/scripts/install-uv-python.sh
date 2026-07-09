#!/usr/bin/env bash
set -e
curl -LsSf https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh
UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python install 3.14
ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python3
ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python
