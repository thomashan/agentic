# Ollama

The recommended way to run Ollama is:

* linux (Nvidia only) `docker run -d --gpus=all -v ollama:/root/.ollama -p 11434:11434 --name ollama ollama/ollama`
* macOS `ollama` CLI

MacOS cannot run Ollama in Docker due to the need for GPU support, which is not available in Docker on macOS.

For more information, see the [Ollama docker documentation](https://ollama.com/blog/ollama-is-now-available-as-an-official-docker-image).

## Models

### Listing Local Models

To list the models available locally in Ollama, you can use the following command:

```bash
ollama list
```

### Available Models

To see the models available for download, you can go to the [Ollama Library Page](https://ollama.com/models) or
[Ollama Search Page](https://ollama.com/search).
The search page allows you to filter models by type, such as LLMs, embeddings, vision and more.

### Adding a Model

To add a model to Ollama, you can use the following command:

```bash
ollama pull <model_name>
```
