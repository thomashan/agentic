# Ollama Setup with Ansible

This directory contains an Ansible playbook for cross-platform Ollama setup that works on both macOS and Linux systems.

## Features

- **Cross-platform support**: Automatically detects OS and uses appropriate installation method
- **macOS**: Uses Homebrew to install Ollama, automatically starts `ollama serve`
- **Linux**: Installs Docker (if needed), runs Ollama in a container with GPU support detection
- **Idempotency**: Safe to run multiple times - won't reinstall if already present
- **Dependency management**: Checks and installs prerequisites (Homebrew on macOS, Docker on Linux)

## Prerequisites

### Install Ansible
```bash
# macOS
brew install ansible

# Linux (Ubuntu/Debian)
sudo apt update && sudo apt install ansible

# Linux (CentOS/RHEL/Fedora)
sudo dnf install ansible
# or
pip install ansible
```

## Usage

### Option 1: Run with the provided script
```bash
./run-ansible.sh
```

### Option 2: Run ansible-playbook directly
```bash
ansible-playbook -i inventory ollama-setup.yml --ask-become-pass -v
```

### Option 3: Run without sudo prompts (if you have passwordless sudo)
```bash
ansible-playbook -i inventory ollama-setup.yml -v
```

## What the playbook does

### macOS Systems
1. ✅ Checks if Homebrew is installed (supports both Intel and Apple Silicon Macs)
2. ✅ Checks if Ollama is already installed via Homebrew
3. 📦 Installs Ollama via `brew install ollama` (if not present)
4. 🚀 Starts `ollama serve` in the background
5. ✅ Verifies Ollama is running on http://localhost:11434

### Linux Systems
1. ✅ Checks if Docker is installed
2. 📦 Installs Docker via package manager (supports Ubuntu/Debian, CentOS/RHEL, Fedora)
3. 🐳 Starts Docker service and adds user to docker group
4. 🎮 Detects GPU runtime support (NVIDIA)
5. 🚀 Runs Ollama container with GPU support (falls back to CPU-only if no GPU)
6. ✅ Verifies Ollama container is running on http://localhost:11434

## Files

- `ollama-setup.yml` - Main Ansible playbook
- `inventory` - Ansible inventory file (localhost)
- `run-ansible.sh` - Convenience script to run the playbook
- `README-ansible.md` - This documentation

## Verification

After running the playbook, you can verify Ollama is working:

```bash
# Check if Ollama is responding
curl http://localhost:11434

# macOS - check version
ollama --version

# Linux - check container status
docker ps | grep ollama

# Test with a simple model
ollama run llama3.2:1b
```

## Troubleshooting

### macOS Issues
- **Homebrew not found**: Install Homebrew from https://brew.sh
- **Permission denied**: Make sure your user has admin privileges

### Linux Issues
- **Docker permission denied**: You may need to log out and log back in after the playbook adds you to the docker group
- **GPU not detected**: The playbook will automatically fall back to CPU-only mode
- **Port 11434 already in use**: Check if Ollama is already running elsewhere

### General Issues
- **Ansible not found**: Install Ansible using the commands in the Prerequisites section
- **Connection issues**: The playbook runs on localhost, so network connectivity isn't required

## Advanced Configuration

You can modify variables in the playbook:

```yaml
vars:
  ollama_port: 11434          # Change the port Ollama runs on
  ollama_container_name: ollama   # Change container name (Linux)
  ollama_volume_name: ollama      # Change volume name (Linux)
```

## Integration with Makefile

The existing Makefile targets (`make ollama-setup`, `make ollama-status`) remain functional. This Ansible playbook provides an alternative approach with more sophisticated dependency management and cross-platform support.
