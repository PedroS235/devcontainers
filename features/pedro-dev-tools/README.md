
# Pedro's Development Tools (pedro-dev-tools)

Installs Neovim, fzf, lazygit, uv, and custom dotfiles configuration

## Example Usage

```json
"features": {
    "ghcr.io/PedroS235/devcontainers/pedro-dev-tools:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| nvimVersion | Version of Neovim to install | string | 0.11.4 |
| nodeVersion | Version of Node.js to install (for Neovim plugins) | string | 22 |
| installDotfiles | Install Pedro's Neovim configuration from dotfiles | boolean | true |
| dotfilesBranch | Branch of the dotfiles repository to use | string | omarchy |
| installUv | Install UV Python package manager | boolean | false |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/PedroS235/devcontainers/blob/main/features/pedro-dev-tools/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
