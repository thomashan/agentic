include make/config.mk
# install/Makefile

.PHONY: install-llm-local-ollama install-llm-local-help

# OS Detection
DETECTED_OS := $(shell uname -s)

install-llm-local-ollama:
	ansible-playbook install/llm/local/ollama-setup.yml

install-llm-local-open-webui:
	ansible-playbook install/llm/local/open-webui-setup.yml

install-llm-local-help:
	@echo "install/llm/local/local.mk targets"
	@printf $(HELP_FORMAT) "install-llm-local-ollama" "Installs Ollama."
	@printf $(HELP_FORMAT) "install-llm-local-open-webui" "Start Open WebUI."
	@printf $(HELP_FORMAT) "install-llm-local-help" "Shows this help message."
