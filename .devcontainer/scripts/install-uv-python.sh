#!/usr/bin/env bash
echo "=== [$(date +%H:%M:%S)] $(basename $0) ==="
set -ex
curl -LsSf --retry 3 --retry-delay 5 --retry-connrefused https://astral.sh/uv/install.sh | env UV_INSTALL_DIR=/usr/local/bin sh
UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python install 3.14
ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python3
ln -sf "$(UV_PYTHON_INSTALL_DIR=/usr/local/share/uv-python uv python find 3.14)" /usr/local/bin/python
