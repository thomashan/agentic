# Docker Setup Action

A cross-platform GitHub Action that ensures Docker CLI and daemon are available on GitHub runners for both Ubuntu and macOS.

## Features

- ✅ **Cross-platform**: Works on both `ubuntu-latest` and `macos-latest` runners
- 🚀 **Smart detection**: Checks if Docker is already running before attempting setup
- 🔧 **Robust error handling**: Comprehensive timeout and error reporting
- 📊 **Detailed logging**: Organized output with GitHub Actions log grouping
- 🧪 **Built-in verification**: Optional hello-world container test

## Usage

### Basic Usage

```yaml
steps:
  - name: Checkout code
    uses: actions/checkout@v4

  - name: Setup Docker
    uses: ./.github/actions/docker-setup

  - name: Run Docker commands
    run: |
      docker --version
      docker build -t my-app .
```

### Advanced Usage

```yaml
steps:
  - name: Setup Docker without verification
    uses: ./.github/actions/docker-setup
    with:
      verify: 'false'
      timeout: '120'
```

### Using Outputs

```yaml
steps:
  - name: Setup Docker
    id: docker-setup
    uses: ./.github/actions/docker-setup

  - name: Print Docker version
    run:
      echo "Docker version: ${{ steps.docker-setup.outputs.docker-version }}"
```

## Inputs

| Input     | Description                                         | Required | Default   |
|-----------|-----------------------------------------------------|----------|-----------|
| `verify`  | Run docker version and hello-world test after setup | No       | `'false'` |
| `timeout` | Timeout in seconds for Docker daemon startup        | No       | `'60'`    |

## Outputs

| Output           | Description                           |
|------------------|---------------------------------------|
| `docker-version` | The version of Docker that was set up |

## Platform-Specific Behavior

### Ubuntu (Linux)

- Uses the system Docker daemon
- Starts and enables the Docker service via systemctl
- Waits for daemon to be ready with configurable timeout

### macOS

- Installs Docker Desktop via Homebrew
- Uses Docker Desktop as the Docker runtime
- Configures appropriate DOCKER_HOST environment variable

## Error Handling

The action includes comprehensive error handling:

- Timeout protection for daemon startup
- Service status reporting on failure
- Clear error messages with troubleshooting info
- Graceful handling of already-running Docker instances

## Examples in This Repository

See these workflow files for usage examples:

- `.github/workflows/ollama.yml` - Updated to use this action
- `.github/workflows/docker-setup-test.yml` - Dedicated test workflow
