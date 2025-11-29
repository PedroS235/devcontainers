FROM osrf/ros:kilted-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
# ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# -----------------------------------------------------------------------------
# Install any ROS-specific dependencies here
# -----------------------------------------------------------------------------
RUN apt update && apt upgrade -y

# -----------------------------------------------------------------------------
# Copy ROS-specific bash configuration
# -----------------------------------------------------------------------------
COPY ./bashconfig.bash /etc/profile.d/extra.bash

# -----------------------------------------------------------------------------
# Final setup
# -----------------------------------------------------------------------------
WORKDIR /workspaces
