# Neoland 

A new homeland for developing AI-native applications.

## Stack

- Homebrew
    - Cask
        - Orbstack
        - Ollama
    - Brew
        - kcat
- Orbstack
    - Dify
    - Kafka
    - RabbitMQ
    - Redis
    - PostgreSQL
    - Clickhouse
- Python 3.10.X
    - Ansible
    - Xinference

## Setup

```shell
git clone https://github.com/zhenyuanlau/neoland.git

cd neoland

make
```

## Play

```shell
make ollama.command-r

make dify.open
```

### Dify

Ollama URL: `http://host.docker.internal:11434`.