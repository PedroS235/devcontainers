#!/bin/bash
set -e

echo "Configuring X11 GUI support..."

# Install basic X11 libraries if not present
apt-get update
apt-get install -y --no-install-recommends \
    libx11-6 \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libxi6

# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/*

echo "X11 GUI support configured successfully!"
echo ""
echo "Note: On the host, you may need to run 'xhost +local:' before starting the container"
echo "to allow X11 connections. This can be added to your devcontainer.json as:"
echo '  "initializeCommand": "xhost +local:"'
