# Knowledge Share for AI, LLM, Agents (Local and Cloud)

This repository is a collection of knowledge and resources related to AI, Large Language Models (LLMs), and agents, øboth in local and cloud environments. It aims to provide a comprehensive guide for developers,
researchers, and enthusiasts interested in these fields.

There maybe some code which I intend to keep as a working example, but the main focus is on knowledge sharing.

If you find this repository useful, please consider giving it a star on GitHub.
If you would like to support the project, you can do so via [Buy Me a Coffee](https://buymeacoffee.com/agentic).
Your support helps keep the project alive and encourages further contributions.

Sometimes there will be a lot of overlap between the models or sections, so please check out each section for more details.
I am working on a section at a time to deep-dive into each topic, so please be patient as I work through them.

There's nothing better than dog fooding, so some responses are obtained from AIs.
Where AI was used to generate the response, there should be a `prompt.md` with responses from various AI models.
The `README.md` with in a directory will contain responses from the chosen AI model.

[Agent](./agent/README.md)

[Coding](./coding/README.md)

[Hardware (Cloud)](./hardware-cloud/README.md)

[Hardware Monitoring](./hardware-monitoring/README.md)

[Image](./image/README.md)

[LLM](./llm/README.md)

[MCP](./mcp/README.md)

[Music](./music/README.md)

[Node](./node/README.md)

[Python](./python/README.md)

[RAG](./rag/README.md)

[Sound](./sound/README.md)

[Tools](install/README.md)

[Training](./training/README.md)

[Video](./video/README.md)

[Voice](./voice/README.md)

## Installation and setup

Sometimes there is nothing better than right the tools for yourself.
The flow of installation and setup is as follows:

1. make (setups miniforge and python)
2. python (setups ansible)
3. ansible (setups other tools)

So `make` is required to bootstrap the whole installation process.

### Prerequisite

As mentioned above, `make` is required to bootstrap the whole installation process.
Once make is present, you can install the rest of the tools.

```
make
```

### Installation

Head over to the [installation](./install/README.md) section for more details.

### Ansible

Right now ansible only targets localhost installation.
But it is possible to install on remote hosts.
