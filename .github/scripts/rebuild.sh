#!/usr/bin/env bash
set -euo pipefail

# Rebuild script for yunionio/website
# Runs on existing source tree (no clone). Installs deps, runs pre-build steps, builds.

# --- Node version ---
# Docusaurus 3.9.2 requires Node >= 20
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -f "$NVM_DIR/nvm.sh" ]; then
    source "$NVM_DIR/nvm.sh"
    nvm install 20 --no-progress
    nvm use 20
fi

echo "Node: $(node --version)"
echo "npm:  $(npm --version)"

# --- Package manager: Yarn classic ---
if ! command -v yarn &>/dev/null; then
    npm install -g yarn
fi

echo "yarn: $(yarn --version)"

# --- Dependencies ---
yarn install --frozen-lockfile

# --- Build ---
# Increase heap size to avoid OOM on large multi-locale builds
export NODE_OPTIONS="--max-old-space-size=6144"
yarn build

echo "[DONE] Build complete."
