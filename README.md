# Devcontainers

This repository contains some of my development containers, where it is tailored to be used with my personal neovim configuration, and for that matter any neovim configuration.

## Ros Devcontainer
For the moment the only available is my devcontainer for ros2 development. I have been using this setup for quite some time now and it works flawlessly. You have all your GUI applications as usual and you have your neovim config inside the container,
making it very seamlessly integration with ROS. You can create more than one container, one for each distro for instance.

Additionally, there is a shared folder, which by default mounts from `./ros/shared` into `/mnt/shared`. (The permissions are set according to your user, so no need to use sudo)

> [!IMPORTANT]
> I am passing the ssh-agent socket inside the container in order to have my ssh keys working inside the container. This is the advised way of using them inside the container. If you don't have an ssh-agent running, you can for instance paste the following in your .bashrc/.zshrc
> which will run the ssh agent and will add the key `id_ed25519` on my `.ssh` folder.
> ```bash
> # ----------- SSH Agent -----------
> 
> if [[ -z "$SSH_AUTH_SOCK" ]] && ! pgrep -u "$USER" ssh-agent > /dev/null; then
>    eval "$(ssh-agent -t 1h)"
>    ssh-add $HOME/.ssh/id_ed25519
> fi
> 
> # -------------- End --------------
> ```

### Script

I offer a script under `./scripts/ros`. This is a simple managing script where you can start one or more of the ros services available, stop, remove and enter. I am using [fzf](https://github.com/junegunn/fzf) in order to choose my desired container I want to enter when more than one service is available.
Before you use the script, you will need to open it and change the variable `DOCKER_COMPOSE_FILE` to match the location of where the `./ros/docker-compose.yml` file is located in your system. Then, to make things easier you can create a symlink to `~/.loca/bin` for instance. Example:
```bash
ln -sf path_to_root/scripts/ros ~/.local/bin
```
> [!NOTE]
> For the above symlink to work, `~/.local/bin` must be in your `$PATH`. If you don't have it yet, you can add the following line to your .bashrc/.zshrc
> ```bash
> export PATH=$PATH:$HOME/.local/bin # Make sure you have ~/.local/bin in your path
> ```
