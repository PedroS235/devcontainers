FROM osrf/ros:humble-desktop-full AS base

ARG USERNAME=user
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ENV DEBIAN_FRONTEND=noninteractive
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp 
ENV NODE_VERSION=22

FROM base AS user_creation

# Deletes user if already in container
RUN if id -u $USER_UID ; then userdel `id -un $USER_UID` ; fi

# Create new user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

RUN mkdir -p /home/$USERNAME/

FROM user_creation AS ros_setup

RUN apt update && apt install --no-install-recommends -y \
    ros-$ROS_DISTRO-rmw-cyclonedds-cpp

RUN mkdir -p /home/$USERNAME/ws/src

FROM ros_setup AS dev_tools

# Install pre-requisites
RUN apt install -y git ninja-build gettext cmake curl build-essential

# Install Neovim
WORKDIR /home/opt/
RUN git clone https://github.com/neovim/neovim && cd neovim \
    && git checkout stable \
    && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

# USER user
# WORKDIR /home/user
#
# # Clone Neovim Config
WORKDIR /home/$USERNAME/.config
RUN git clone https://github.com/PedroS235/nvim.git

# # Install Nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_VERSION.x -o nodesource_setup.sh 
RUN bash nodesource_setup.sh && rm nodesource_setup.sh
RUN sudo apt-get install -y nodejs

# Install Fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
RUN ~/.fzf/install --all

# Install Lazygit
RUN LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*') && \
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz" && \
    tar xf lazygit.tar.gz lazygit && \
    sudo install lazygit /usr/local/bin && \
    rm lazygit.tar.gz lazygit

# Install Cargo 
USER $USERNAME
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y
ENV PATH=/home/$USERNAME/.cargo/bin:$PATH

# Install Mprocs
RUN cargo install mprocs

USER root

# Install Starship
RUN curl -sS https://starship.rs/install.sh | sh -s -- -y

FROM dev_tools AS dotfiles

# Setup .bashrc
COPY config/bashrc /home/$USERNAME/.bashrc
COPY config/gitconfig /home/$USERNAME/.gitconfig

WORKDIR /home/$USERNAME
USER $USERNAME
CMD ["/bin/bash"]
