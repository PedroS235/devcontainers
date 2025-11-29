FROM osrf/ros:kilted-desktop-full

ENV DEBIAN_FRONTEND=noninteractive
# ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

# -----------------------------------------------------------------------------
# Remove existing user with UID 1000 (if exists)
# This is required because ROS images often have a default user at UID 1000
# which conflicts with common-utils feature creating devuser at UID 1000
# -----------------------------------------------------------------------------
RUN if id 1000 &>/dev/null; then \
    echo "Removing existing user with UID 1000: $(id -un 1000)"; \
    userdel -r $(id -un 1000) 2>/dev/null || true; \
    fi

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
