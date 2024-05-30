PY := python3.10
VENV_PATH := .venv
BIN_PATH := $(VENV_PATH)/bin

PIP := $(BIN_PATH)/pip
ANSIBLE := $(BIN_PATH)/ansible
PLAY := $(BIN_PATH)/ansible-playbook
GALAXY := $(BIN_PATH)/ansible-galaxy

COMPONENTS := postgres redis kafka rabbitmq clickhouse litellm

.PHONY: default setup land clean

default: setup land

setup: venv pip.install ansible.galaxy brew.bundle

venv:
	$(PY) -m venv $(VENV_PATH)

pip.freeze:
	$(PIP) freeze > requirements.txt

pip.install:
	$(PIP) install --upgrade -r requirements.txt

ansible.galaxy:
	@$(GALAXY) collection install community.docker --force

brew.bundle:
	@brew bundle

land:
	@$(PLAY) playbooks/site.yml -t land

$(COMPONENTS):
	@$(PLAY) playbooks/site.yml -t $@

ollama.llama3:
	-ollama pull llama3

ollama.dolphincoder:
	-ollama pull dolphincoder

ollama.llm: ollama.llama3 ollama.dolphincoder

docs: clean
	@npx -p antora -p asciidoctor-kroki -c 'antora local-antora-playbook.yml'

docs.server: docs
	@npx http-server build/site -c-1

open:
	@open http://127.0.0.1:4000/ui

clean:
	@rm -fr build/site