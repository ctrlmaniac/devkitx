# Devcontainer mount directory

This directory is mounted into the devcontainer at `/mnt`.

It is intended for storing data that you want to persist across devcontainer rebuilds, such as:

- Large datasets
- Pre-trained models
- Configuration files
- Build artifacts

**Important:** Do not store sensitive information in this directory.
