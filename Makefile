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

setup: venv pip.install ansible.galaxy brew.bundle npm.install

venv:
	$(PY) -m venv $(VENV_PATH)

pip.freeze:
	$(PIP) freeze > requirements.txt

pip.install:
	$(PIP) install --upgrade -r requirements.txt

npm.install:
	@npm install

ansible.galaxy:
	@$(GALAXY) collection install community.docker --force

brew.bundle:
	@brew bundle

land:
	@$(PLAY) playbooks/site.yml -t land

$(COMPONENTS):
	@$(PLAY) playbooks/site.yml -t $@

ollama.llama3:
	-ollama run llama3

ollama.dolphincoder:
	-ollama run dolphincoder

antora: clean
	@npx antora local-antora-playbook.yml

guide: antora
	@npx http-server build/site -c-1

open:
	@open http://127.0.0.1:4000

clean:
	@rm -fr build/site