#!/bin/bash

# Script to run the Ollama setup Ansible playbook
# Usage: ./run-ansible.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR"
PLAYBOOK="$ANSIBLE_DIR/ollama-setup.yml"
INV_FILE="$ANSIBLE_DIR/inventory"

# Helper function for running ansible-playbook
run_ansible() { ansible-playbook -i "$INV_FILE" "$PLAYBOOK" "$@"; }

echo "🚀 Running Ollama setup with Ansible..."
echo "Playbook: $PLAYBOOK"
echo "Inventory: $INV_FILE"
echo ""

# Check if Ansible is installed
if ! command -v ansible-playbook &> /dev/null; then
    echo "❌ ansible-playbook is not installed."
    echo "Please install Ansible first:"
    echo "  macOS: brew install ansible"
    echo "  Linux: pip install ansible"
    exit 1
fi

# Run the playbook
run_ansible --ask-become-pass -v

echo ""
echo "✅ Ansible playbook completed!"
echo "🎉 Ollama should now be running on http://localhost:11434"
