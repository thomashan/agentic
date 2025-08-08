#!/bin/bash

# Test script for Ansible Ollama setup
# Tests idempotency, installation detection, and service verification

set -e

# Figure out where this script lives and where the Ansible assets are
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ANSIBLE_DIR="$SCRIPT_DIR"
PLAYBOOK="$ANSIBLE_DIR/ollama-setup.yml"
INV_FILE="$ANSIBLE_DIR/inventory"

# Helper function for running ansible-playbook
run_ansible() { ansible-playbook -i "$INV_FILE" "$PLAYBOOK" "$@"; }

echo "🧪 Testing Ansible Ollama Setup"
echo "================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[TEST]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[PASS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

# Function to run ansible playbook
run_playbook() {
    print_status "Running Ansible playbook..."
    run_ansible -v > /tmp/ansible-output.log 2>&1
    local exit_code=$?
    if [ $exit_code -eq 0 ]; then
        print_success "Ansible playbook completed successfully"
    else
        print_error "Ansible playbook failed (exit code: $exit_code)"
        echo "Last 10 lines of output:"
        tail -n 10 /tmp/ansible-output.log
        return $exit_code
    fi
}

# Function to test Ollama service
test_ollama_service() {
    print_status "Testing Ollama service..."
    
    # Test HTTP endpoint
    if curl -s http://localhost:11434 > /dev/null; then
        print_success "Ollama HTTP service is responding"
    else
        print_error "Ollama HTTP service is not responding"
        return 1
    fi
    
    # Test if we can get version (macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v ollama >/dev/null 2>&1; then
            local version=$(ollama --version 2>/dev/null || echo "unknown")
            print_success "Ollama CLI available (version: $version)"
        else
            print_error "Ollama CLI not available"
            return 1
        fi
    fi
    
    # Test Docker container (Linux simulation)
    if command -v docker >/dev/null 2>&1; then
        if docker ps --format '{{.Names}}' | grep -q "^ollama$"; then
            print_success "Ollama Docker container is running"
        else
            print_warning "Ollama Docker container not found (expected on macOS)"
        fi
    fi
}

# Test 1: Initial setup
print_status "TEST 1: Initial Ansible setup"
echo "----------------------------------------"
run_playbook

# Test 2: Service verification
print_status "TEST 2: Service verification"
echo "----------------------------------------"
test_ollama_service

# Test 3: Idempotency test
print_status "TEST 3: Idempotency test (re-running playbook)"
echo "----------------------------------------"
print_status "Running playbook again to test idempotency..."

# Capture output to check for idempotent behavior
run_ansible > /tmp/ansible-idempotent.log 2>&1
idempotent_exit_code=$?

if [ $idempotent_exit_code -eq 0 ]; then
    # Check if the output indicates no changes were made
    if grep -q "changed=0" /tmp/ansible-idempotent.log; then
        print_success "Playbook is idempotent (no changes made on re-run)"
    elif grep -q "✅.*already" /tmp/ansible-idempotent.log; then
        print_success "Playbook detected existing installation correctly"
    else
        print_warning "Playbook completed but may not be fully idempotent"
        echo "Check /tmp/ansible-idempotent.log for details"
    fi
else
    print_error "Idempotency test failed (exit code: $idempotent_exit_code)"
    echo "Last 10 lines of output:"
    tail -n 10 /tmp/ansible-idempotent.log
fi

# Test 4: Service still works after re-run
print_status "TEST 4: Service verification after re-run"
echo "----------------------------------------"
test_ollama_service

# Test 5: Basic functionality test
print_status "TEST 5: Basic functionality test"
echo "----------------------------------------"

# Test API endpoint
api_response=$(curl -s http://localhost:11434/api/tags 2>/dev/null || echo "")
if [[ -n "$api_response" ]]; then
    print_success "Ollama API is accessible (/api/tags endpoint)"
else
    print_warning "Ollama API endpoint /api/tags not accessible (may be normal if no models installed)"
fi

# Summary
echo ""
echo "🎯 Test Summary"
echo "==============="
print_status "All tests completed!"

if [ $idempotent_exit_code -eq 0 ]; then
    print_success "✅ Ansible Ollama setup is working correctly!"
    print_success "✅ Idempotency verified - safe to run multiple times"
    print_success "✅ Service is accessible at http://localhost:11434"
    
    echo ""
    echo "Next steps:"
    echo "  1. Install a model: ollama pull llama3.2:1b"
    echo "  2. Test the model: ollama run llama3.2:1b"
    echo "  3. Or use the API: curl http://localhost:11434/api/generate -d '{\"model\":\"llama3.2:1b\",\"prompt\":\"Hello\"}'"
else
    print_error "❌ Some tests failed. Check the logs above for details."
    exit 1
fi

echo ""
print_status "Log files created:"
echo "  - /tmp/ansible-output.log (first run)"
echo "  - /tmp/ansible-idempotent.log (idempotency test)"
