# Pedro's Development Tools (pedro-dev-tools)

A comprehensive development environment setup featuring Neovim, modern CLI tools, and personalized configurations.

## What's Included

- **Neovim** - Latest stable version with custom configuration
- **Node.js** - Required for Neovim plugins
- **fzf** - Fuzzy finder for command-line
- **lazygit** - Terminal UI for git commands
- **UV** - Fast Python package manager
- **Custom dotfiles** - Personal Neovim configuration from GitHub

## Usage

```json
{
  "features": {
    "ghcr.io/pedros235/devcontainers/pedro-dev-tools:1": {}
  }
}
```

## Options

| Option            | Type    | Default     | Description                           |
| ----------------- | ------- | ----------- | ------------------------------------- |
| `nvimVersion`     | string  | `"0.11.4"`  | Version of Neovim to install          |
| `nodeVersion`     | string  | `"22"`      | Version of Node.js for Neovim plugins |
| `installDotfiles` | boolean | `true`      | Install custom Neovim configuration   |
| `dotfilesBranch`  | string  | `"omarchy"` | Branch of dotfiles repository to use  |
| `installUv`       | boolean | `false`     | Install UV Python package manager     |

## Example Configuration

```json
{
  "features": {
    "ghcr.io/pedros235/devcontainers/pedro-dev-tools:1": {
      "nvimVersion": "0.11.4",
      "nodeVersion": "22",
      "installDotfiles": true,
      "dotfilesBranch": "omarchy",
      "installUv": false
    }
  }
}
```

## Dependencies

This feature should be installed after `common-utils` to ensure proper user setup:

```json
{
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "username": "devuser"
    },
    "ghcr.io/pedros235/devcontainers/pedro-dev-tools:1": {}
  }
}
```

## Notes

- Tools are installed for the configured remote user (via `_REMOTE_USER` environment variable)
- UV is added to PATH automatically via `.bashrc`
- Dotfiles are cloned from https://github.com/PedroS235/.dotfiles
