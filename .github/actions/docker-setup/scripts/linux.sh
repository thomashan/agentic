#!/usr/bin/env bash
set -euo pipefail

echo "::group::Setting up Docker on Linux"

# Check if Docker is already available and running
if docker version &> /dev/null && docker info &> /dev/null; then
    echo "✅ Docker is already running and accessible"
    docker --version
    echo "::endgroup::"
    exit 0
fi

echo "🔧 Starting Docker daemon..."

# Ensure Docker daemon is running
sudo systemctl start docker || sudo service docker start || {
    echo "❌ Failed to start Docker daemon"
    exit 1
}

# Enable Docker to start on boot (optional, but good practice)
sudo systemctl enable docker || true

# Wait for Docker to be ready with timeout
echo "⏳ Waiting for Docker daemon to be ready..."
timeout=30
until docker info &> /dev/null; do
    ((timeout--)) || {
        echo "❌ Docker daemon failed to start within 30 seconds"
        echo "Docker service status:"
        sudo systemctl status docker || true
        exit 1
    }
    echo "  ... waiting (${timeout}s remaining)"
    sleep 1
done

echo "✅ Docker daemon is ready"
docker --version
docker info --format '{{.ServerVersion}} ({{.Driver}} storage driver)'

echo "::endgroup::"
