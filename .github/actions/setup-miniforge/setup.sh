#!/usr/bin/env bash
set -euo pipefail

echo "::group::Setting up Miniforge"

if command -v conda &> /dev/null; then
    echo "✅ Conda is already available"
    conda --version
    echo "::endgroup::"
    exit 0
fi

OS=$(uname -s)
ARCH=$(uname -m)

if [[ "$OS" == "Linux" ]]; then
    INSTALLER_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-${ARCH}.sh"
elif [[ "$OS" == "Darwin" ]]; then
    INSTALLER_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-${ARCH}.sh"
else
    echo "Unsupported OS: $OS"
    exit 1
fi

echo "Downloading Miniforge installer from $INSTALLER_URL"
curl -L -o miniforge.sh "$INSTALLER_URL"

echo "Installing Miniforge..."
bash miniforge.sh -b -p "$HOME/miniforge"

echo "Adding Miniforge to PATH"
echo "$HOME/miniforge/bin" >> $GITHUB_PATH

echo "Initializing Conda for bash..."
# Sourcing activate and running conda init is important for subsequent steps
# that might need a fully initialized conda environment.
source "$HOME/miniforge/bin/activate"
conda init bash

echo "✅ Miniforge setup complete"

echo "::endgroup::"
