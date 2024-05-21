# AI Infra

A basic IaC implementation for macOS designed to run AI-native applications, which requires Homebrew and Python 3.10.x.

The system utilizes Multipass to manage virtual machines (VMs) and employs Ansible to install Dify and Xinference.

## Setup

```shell
git clone https://github.com/zhenyuanlau/ainfra.git

cd ainfra

# Run locally using Multipass, or modify the hosts.ini file to update your host entries.
make inventory

make
```

## Play

```shell
make dify.open

make xinference.open
```