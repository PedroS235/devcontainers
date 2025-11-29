# Source ROS env
source /opt/ros/$ROS_DISTRO/setup.bash

# Exports
export PATH=$PATH:$HOME/.cargo/bin:$HOME/.local/bin
# Aliases
alias nv=nvim
alias colconbuild='colcon build --symlink-install --continue-on-error --cmake-args -DCMAKE_EXPORT_COMPILE_COMMANDS=ON'
alias colconsource='source install/setup.bash'
alias lz=lazygit
# Enable vim mode
set -o vi
