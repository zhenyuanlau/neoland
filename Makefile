PY := python3.10
VENV_PATH := .venv
BIN_PATH := $(VENV_PATH)/bin

PIP := $(BIN_PATH)/pip
ANSIBLE := $(BIN_PATH)/ansible
PLAY := $(BIN_PATH)/ansible-playbook
GALAXY := $(BIN_PATH)/ansible-galaxy

COMPONENTS := postgres metabase redis kafka rabbitmq clickhouse nacos localstack litellm livebook

.PHONY: default setup land clean

default: setup land

setup: venv pip.install npm.install ansible.galaxy brew.bundle

venv:
	$(PY) -m venv $(VENV_PATH)

pip.freeze:
	$(PIP) freeze > requirements.txt

pip.install:
	$(PIP) install --upgrade -r requirements.txt

npm.install:
	@npm install

ansible.galaxy:
	@$(GALAXY) collection install community.docker --upgrade
	@$(GALAXY) collection install kubernetes.core --upgrade

brew.bundle:
	@brew bundle

land:
	@$(PLAY) playbooks/site.yml -t land

$(COMPONENTS):
	@$(PLAY) playbooks/site.yml -t component,$@

ollama.llama3:
	-ollama pull llama3

ollama.dolphincoder:
	-ollama pull dolphincoder

ollama.llm: ollama.llama3 ollama.dolphincoder

jupyter.lab:
	$(PY) -m jupyter lab --NotebookApp.notebook_dir=./notebooks

livebook.open:
	@open http://127.0.0.1:8080/

litellm.ui:
	@open http://127.0.0.1:4444/ui

antora:
	@watchexec -w docs -- npx antora antora-playbook.yml
