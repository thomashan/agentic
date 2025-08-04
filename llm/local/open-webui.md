# Open WebUI

Open WebUI is a web-based interface for interacting with LLMs, designed to be lightweight and easy to use.
It supports various models and provides a simple way to run inference without needing extensive setup.
The recommended way to run Open WebUI is via Docker, which simplifies the process of managing dependencies and configurations.
For more information on running Open WebUI with Docker, see the [Open WebUI documentation](https://docs.openwebui.com/).

## macOS

Make sure Ollama is running in the background before starting Open WebUI. You can start Ollama with the command:

```
ollama serve
```

To run Open WebUI on macOS, you can use the following command:

```
docker run -d -p 3000:8080 --add-host=host.docker.internal:host-gateway -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:main
```

## Linux (Nvidia only)

To run Open WebUI on Linux, you can use the following Docker command:

```
docker run -d -p 3000:8080 --gpus=all -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama
```
