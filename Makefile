include make/config.mk
include install/install.mk

.DEFAULT_GOAL := activate-conda-env

# Colors (disable in CI)
ifeq ($(CI),true)
ORANGE_BOLD := 
RESET := 
else
ORANGE_BOLD := \033[1;38;5;208m
RESET := \033[0m
endif

.PHONY: install-homebrew install-miniforge create-conda-env activate-conda-env help

# OS Detection
DETECTED_OS := $(shell uname -s)

# CI Detection
CI ?= false

# Install Homebrew if not installed (macOS)
install-homebrew:
	@if [ "$(DETECTED_OS)" = "Darwin" ]; then \
		if ! command -v brew >/dev/null 2>&1; then \
			echo "Homebrew not found. Installing Homebrew..."; \
			/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || exit 1; \
		else \
			echo "Homebrew is already installed."; \
		fi; \
	fi


# Install miniforge based on operating system
install-miniforge: install-homebrew
	@echo "Installing miniforge for $(DETECTED_OS)..."
	@if [ "$(DETECTED_OS)" = "Darwin" ]; then \
		if brew list --cask miniforge >/dev/null 2>&1; then \
			echo "✅ Miniforge is already installed."; \
		else \
			echo "Detected macOS - installing via Homebrew..."; \
			brew install --cask miniforge || exit 1; \
			echo "✅ Miniforge installed successfully"; \
			echo "Please restart your terminal or run the $(ORANGE_BOLD)conda init$(RESET) command for your shell."; \
		fi; \
	elif [ "$(DETECTED_OS)" = "Linux" ]; then \
		echo "Detected Linux - detecting architecture..."; \
		ARCH=$$(uname -m); \
		echo "DEBUG: ARCH is $$ARCH"; \
		case "$$ARCH" in \
			x86_64) MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh";; \
			aarch64) MINIFORGE_URL="https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-aarch64.sh";; \
			*) echo "❌ Unsupported Linux architecture: $$ARCH"; exit 1;; \
		esac; \
		echo "Checking for wget..."; \
		if ! command -v wget >/dev/null 2>&1; then \
			echo "⚠️  wget not found. In CI environments, wget should be pre-installed."; \
			echo "If running locally, please install wget for your distribution:"; \
			echo "  Ubuntu/Debian: sudo apt-get install wget"; \
			echo "  RHEL/CentOS: sudo yum install wget"; \
			echo "  Fedora: sudo dnf install wget"; \
			echo "  Arch: sudo pacman -S wget"; \
			echo "  openSUSE: sudo zypper install wget"; \
			if [ "$$CI" = "true" ]; then \
				echo "❌ CI environment should have wget pre-installed"; \
				exit 1; \
			else \
				echo "❌ Please install wget and try again"; \
				exit 1; \
			fi; \
		fi; \
		wget $$MINIFORGE_URL -O miniforge.sh; \
		echo "Installing Miniforge to $$HOME/miniforge3..."; \
		bash miniforge.sh -b -u -p $$HOME/miniforge3 || { echo "❌ Miniforge installation failed"; exit 1; }; \
		rm miniforge.sh; \
		echo "✅ Miniforge installed successfully"; \
		if [ "$$CI" = "true" ]; then \
			echo "In CI: Miniforge installed at $$HOME/miniforge3"; \
		else \
			echo "Please restart your terminal or run the $(ORANGE_BOLD)conda init$(RESET) command for your shell."; \
		fi; \
	else \
		echo "❌ Unsupported operating system: $(DETECTED_OS)"; \
		exit 1; \
	fi


# Create conda environment with Python 3.12
create-conda-env: install-miniforge
	@echo "Creating conda environment 'agentic' from environment.yml..."
	@if [ "$(DETECTED_OS)" = "Darwin" ]; then \
		CONDA_PATH="$$(which conda)"; \
	elif [ "$(DETECTED_OS)" = "Linux" ]; then \
		CONDA_PATH="$$HOME/miniforge3/bin/conda"; \
		if [ ! -x "$$CONDA_PATH" ]; then \
			echo "❌ Conda not found at $$CONDA_PATH"; \
			echo "Miniforge installation may have failed"; \
			exit 1; \
		fi; \
	else \
		echo "❌ Unsupported OS for conda detection"; \
		exit 1; \
	fi; \
	if "$$CONDA_PATH" env list | grep -q "agentic"; then \
		echo "✅ Environment 'agentic' already exists"; \
	else \
		echo "Creating new environment..."; \
		"$$CONDA_PATH" env create -n agentic -f environment.yml; \
		echo "✅ Environment 'agentic' created successfully"; \
		echo "To activate the environment, run:"; \
		echo "  conda activate agentic"; \
	fi


# Activate conda environment
activate-conda-env: create-conda-env
	@echo "To activate the environment, run the following command:"
	@echo "conda activate agentic"


help:
	@echo "Usage: make [target]"
	@echo "All targets should be executed from the root directory. (i.e., where this Makefile is located)"
	@echo ""
	@echo "Available targets:"
	@printf $(HELP_FORMAT) "install-homebrew" "Installs homebrew for macOS only."
	@printf $(HELP_FORMAT) "install-miniforge" "Installs Miniforge."
	@printf $(HELP_FORMAT) "create-conda-env" "Creates the conda environment 'agentic'."
	@printf $(HELP_FORMAT) "activate-conda-env" "Shows the command to activate the conda environment."
	@printf $(HELP_FORMAT) "help" "Shows this help message."
	@echo ""
	@$(MAKE) install-help
