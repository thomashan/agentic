# install/Makefile

include make/config.mk
include install/llm/local/local.mk

.PHONY: install-prerequisites install-help

# OS Detection
DETECTED_OS := $(shell uname -s)

install-prerequisites:
	@echo "Installing prerequisites for $(DETECTED_OS)..."
	@if [ "$(DETECTED_OS)" = "Darwin" ]; then \
		ansible-playbook install/prerequisite/macos.yml; \
	elif [ "$(DETECTED_OS)" = "Linux" ]; then \
		ansible-playbook install/prerequisite/linux.yml; \
	else \
		echo "Unsupported OS: $(DETECTED_OS)"; \
		exit 1; \
	fi

install-help:
	@echo "install/install.mk targets"
	@printf $(HELP_FORMAT) "install-prerequisites" "Installs prerequisites like Docker and nvm."
	@printf $(HELP_FORMAT) "install-help" "Shows this help message."
	@echo ""
	@$(MAKE) install-llm-local-help
