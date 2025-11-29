#!/bin/bash
set -e

# Import options from devcontainer-feature.json
NVIM_VERSION="${NVIMVERSION:-0.11.4}"
NODE_VERSION="${NODEVERSION:-22}"
INSTALL_DOTFILES="${INSTALLDOTFILES:-true}"
DOTFILES_BRANCH="${DOTFILESBRANCH:-omarchy}"
INSTALL_UV="${INSTALLUV:-true}"

echo "Installing Pedro's Development Tools..."
echo "  Neovim version: ${NVIM_VERSION}"
echo "  Node version: ${NODE_VERSION}"
echo "  Install dotfiles: ${INSTALL_DOTFILES}"
echo "  Install UV: ${INSTALL_UV}"

# -----------------------------------------------------------------------------
# Install Neovim
# -----------------------------------------------------------------------------
echo "Installing Neovim ${NVIM_VERSION}..."
curl -LO "https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux-x86_64.tar.gz"
tar xzvf nvim-linux-x86_64.tar.gz
mv nvim-linux-x86_64 /usr/local
ln -sf /usr/local/nvim-linux-x86_64/bin/nvim /usr/bin/nvim
rm nvim-linux-x86_64.tar.gz

# -----------------------------------------------------------------------------
# Install Node.js (for Neovim plugins)
# -----------------------------------------------------------------------------
echo "Installing Node.js ${NODE_VERSION}..."
curl -fsSL "https://deb.nodesource.com/setup_${NODE_VERSION}.x" -o nodesource_setup.sh
bash nodesource_setup.sh
apt-get install -y nodejs
rm nodesource_setup.sh

# -----------------------------------------------------------------------------
# Detect the non-root user to install tools for
# -----------------------------------------------------------------------------
USER_HOME="/root"
INSTALL_USER="root"

# Try to find a non-root user (created by common-utils feature)
# Look for users with UID >= 1000 and < 60000 (avoiding system users)
DETECTED_USER=$(getent passwd | awk -F: '$3 >= 1000 && $3 < 60000 { print $1; exit }')

if [ -n "${DETECTED_USER}" ]; then
    INSTALL_USER="${DETECTED_USER}"
    USER_HOME=$(getent passwd "${DETECTED_USER}" | cut -d: -f6)
    echo "Installing tools for detected user: ${INSTALL_USER}"
elif [ -n "${_REMOTE_USER}" ] && [ "${_REMOTE_USER}" != "root" ]; then
    INSTALL_USER="${_REMOTE_USER}"
    USER_HOME="/home/${_REMOTE_USER}"
    echo "Installing tools for remote user: ${INSTALL_USER}"
else
    echo "Installing tools for root user"
fi

# Verify home directory exists
if [ ! -d "${USER_HOME}" ]; then
    echo "ERROR: Home directory ${USER_HOME} does not exist!"
    exit 1
fi

# Function to run commands as the target user
run_as_user() {
    if [ "${INSTALL_USER}" = "root" ]; then
        bash -c "$1"
    else
        su - "${INSTALL_USER}" -c "$1"
    fi
}

# -----------------------------------------------------------------------------
# Install Pedro's Neovim config
# -----------------------------------------------------------------------------
if [ "${INSTALL_DOTFILES}" = "true" ]; then
    echo "Installing Neovim dotfiles from branch ${DOTFILES_BRANCH}..."
    run_as_user "cd ${USER_HOME} && \
        git clone -b ${DOTFILES_BRANCH} https://github.com/PedroS235/.dotfiles.git && \
        mkdir -p ${USER_HOME}/.config && \
        mv .dotfiles/dots/.config/nvim ${USER_HOME}/.config/nvim && \
        rm -rf .dotfiles"
fi

# -----------------------------------------------------------------------------
# Install fzf
# -----------------------------------------------------------------------------
echo "Installing fzf..."
run_as_user "git clone --depth 1 https://github.com/junegunn/fzf.git ${USER_HOME}/.fzf && \
    ${USER_HOME}/.fzf/install --all"

# -----------------------------------------------------------------------------
# Install lazygit
# -----------------------------------------------------------------------------
echo "Installing lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
curl -Lo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
tar xf /tmp/lazygit.tar.gz -C /tmp lazygit
install /tmp/lazygit /usr/local/bin
rm /tmp/lazygit.tar.gz /tmp/lazygit

# -----------------------------------------------------------------------------
# Install UV Python package manager
# -----------------------------------------------------------------------------
if [ "${INSTALL_UV}" = "true" ]; then
    echo "Installing UV..."
    run_as_user "curl -LsSf https://astral.sh/uv/install.sh | sh"

    # Add to PATH
    if [ ! -f "${USER_HOME}/.bashrc" ]; then
        run_as_user "touch ${USER_HOME}/.bashrc"
    fi
    run_as_user "echo 'export PATH=\"\$PATH:${USER_HOME}/.local/bin\"' >> ${USER_HOME}/.bashrc"
fi

echo "Pedro's Development Tools installed successfully!"
