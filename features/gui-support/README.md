# X11 GUI Support (gui-support)

Enables X11 forwarding for running GUI applications (like RViz2, Gazebo, etc.) from within your development container.

## What's Included

- X11 socket mount (`/tmp/.X11-unix`)
- DISPLAY environment variable configuration
- Required X11 client libraries

**Note:** This feature does NOT enable privileged mode by default. For hardware-accelerated graphics (GPU access, OpenGL, Vulkan) or 3D applications (Gazebo, RViz2), you may need to add `"privileged": true` to your devcontainer.json.

## Usage

```json
{
  "features": {
    "ghcr.io/pedros235/devcontainers/gui-support:1": {}
  },
  "initializeCommand": "xhost +local:"
}
```

**Important:** You must include `"initializeCommand": "xhost +local:"` in your devcontainer.json to allow X11 connections from the container.

## Example: Basic GUI Support

For simple GUI applications (basic X11 forwarding):
```json
{
  "name": "Development with GUI",
  "initializeCommand": "xhost +local:",
  "features": {
    "ghcr.io/pedros235/devcontainers/gui-support:1": {}
  }
}
```

## Example: ROS with Hardware-Accelerated GUI

For 3D applications, simulators, or hardware-accelerated graphics (RViz2, Gazebo):
```json
{
  "name": "ROS Development with GUI",
  "initializeCommand": "xhost +local:",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "features": {
    "ghcr.io/devcontainers/features/common-utils:2": {
      "username": "devuser"
    },
    "ghcr.io/pedros235/devcontainers/pedro-dev-tools:1": {},
    "ghcr.io/pedros235/devcontainers/gui-support:1": {}
  },
  "privileged": true,
  "runArgs": ["--network=host"]
}
```

## What Gets Configured

- **Mount:** `/tmp/.X11-unix` from host → container (X11 socket)
- **Environment:** `DISPLAY` variable forwarded from host
- **Libraries:** Essential X11 client libraries installed

**Not included by default:**
- Privileged mode (add manually if needed for GPU/hardware acceleration)

## Use Cases

- Running ROS visualization tools (RViz, RViz2)
- Running Gazebo or other simulators
- Any GUI application that requires X11 forwarding
- Testing desktop applications in isolated environments

## Security Note

This feature enables X11 forwarding, which allows container access to your display. Only use in trusted development environments.

**Privileged mode:** If you add `"privileged": true` for hardware acceleration:
- This gives the container almost all host capabilities
- Only enable when necessary (3D graphics, GPU access)
- Never use in production or untrusted environments
- Consider alternatives like specific `--device` mappings or capabilities when possible

For production deployments, consider more restrictive X11 configurations or alternative approaches like VNC.

## When is Privileged Mode Required?

**Usually NOT needed for:**
- Simple GUI applications
- Basic terminal applications with X11
- 2D graphics applications

**Usually REQUIRED for:**
- RViz2, Gazebo, or other 3D simulators
- Hardware-accelerated OpenGL/Vulkan applications
- Direct GPU access
- Some graphics-intensive applications

**Recommendation:** Start without privileged mode. If you see graphics errors or poor performance, then add `"privileged": true` to your devcontainer.json.
