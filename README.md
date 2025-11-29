# Devcontainers

A collection of development container templates and reusable features using the [devcontainer.json](https://containers.dev/) specification and [DevPod](https://devpod.sh/).

## Background

After maintaining various development containers primarily for ROS development—complete with custom Dockerfiles, GUI app support, bash automation scripts, and later Docker Compose files—I've transitioned to a more universal approach that works across different editors (Vim/Neovim, VSCode, Cursor, etc.) by adopting the devcontainer.json philosophy together with DevPod.

This system is more flexible than my previous global Docker Compose setup, providing per-project isolation while maintaining the same streamlined development workflow.

## Features

This repository provides **reusable devcontainer features** that can be used in any project:

### pedro-dev-tools

**`ghcr.io/pedros235/devcontainers/pedro-dev-tools:1`**

A comprehensive development environment with:

- Neovim (v0.11.4) with custom configuration
- Node.js (for Neovim plugins)
- fzf (fuzzy finder)
- lazygit (terminal UI for git)
- UV (Python package manager)
- Custom dotfiles from GitHub

[View feature documentation →](features/pedro-dev-tools/README.md)

### gui-support

**`ghcr.io/pedros235/devcontainers/gui-support:1`**

X11 GUI support for running graphical applications (RViz, Gazebo, etc.) in containers:

- X11 socket mounting
- DISPLAY environment variable
- Required X11 libraries
- Privileged container mode

[View feature documentation →](features/gui-support/README.md)

## Templates

Pre-configured templates demonstrating feature usage:

### ROS Development (`ros/kilted.template`)

ROS Kilted development environment with GUI support for RViz2 and other visualization tools.

**Features used:**

- `common-utils` - User creation and sudo access
- `pedro-dev-tools` - Development tooling
- `gui-support` - X11 forwarding for RViz2

### Python Development (`python`)

Python development environment with UV package manager.

**Features used:**

- `common-utils` - User creation and sudo access
- `python` - Python installation
- `pedro-dev-tools` - Development tooling

## Getting Started

### Prerequisites

Install DevPod:

- **Website**: https://devpod.sh/
- **CLI Installation**: https://devpod.sh/docs/getting-started/install

### Using Templates

1. Copy a template to your project directory
2. Adapt the Dockerfile to include your project-specific dependencies
3. Run `devpod up . --ide none` to create the container

DevPod will automatically set up the SSH config, allowing you to simply `ssh <containername>` to access the container.

**Example with IDE auto-detection:**

```bash
cd ros/kilted.template
devpod up .
```

This will open a supported IDE if installed, or fall back to a web-based VSCode instance.

**Example with no IDE (SSH only):**

```bash
devpod up . --ide none
```

### Using Features in Your Own Projects

Add features to your `devcontainer.json`:

```json
{
  "name": "My Project",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "username": "devuser"
    },
    "ghcr.io/pedros235/devcontainers/pedro-dev-tools:1": {
      "nvimVersion": "0.11.4",
      "installUv": true
    }
  },
  "remoteUser": "devuser"
}
```

For projects needing GUI support, add:

```json
{
  "initializeCommand": "xhost +local:",
  "features": {
    "ghcr.io/pedros235/devcontainers/gui-support:1": {}
  }
}
```

### VSCode Users

The templates and features work seamlessly with the VSCode Dev Containers extension.

## Publishing Features

Features are automatically published to GitHub Container Registry via GitHub Actions. To publish:

1. Make changes to features in the `features/` directory
2. Commit and push to the `main` branch
3. Go to **Actions** → **Release Dev Container Features** → **Run workflow**
4. After first publish, make packages public in [GitHub Packages settings](https://github.com/PedroS235?tab=packages)
