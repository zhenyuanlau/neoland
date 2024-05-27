PY := python3.10
VENV_PATH := .venv
BIN_PATH := $(VENV_PATH)/bin

PIP := $(BIN_PATH)/pip
ANSIBLE := $(BIN_PATH)/ansible
PLAY := $(BIN_PATH)/ansible-playbook
GALAXY := $(BIN_PATH)/ansible-galaxy

XINF := $(BIN_PATH)/xinference
XINF_LOCAL := $(BIN_PATH)/xinference-local

COMPONENTS := postgres redis kafka rabbitmq clickhouse

.PHONY: default setup land

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

dify.open:
	@open https://nginx.dify.orb.local

ollama.command-r:
	@ollama run command-r:35b

xinf.start:
	XINFERENCE_MODEL_SRC=modelscope $(XINF_LOCAL) --host 0.0.0.0 --port 9997

xinf.rerank:
	@$(XINF) launch --model-name bge-reranker-v2-m3 --model-type rerank

xinf.qwen:
	@$(XINF) launch --model-name qwen1.5-chat --size-in-billions 32 --model-format pytorch --quantization 8-bit --model-engine transformers

antora.generate:
	@rm -fr build/site
	@npx antora local-antora-playbook.yml

antora.preview: antora.generate
	@npx http-server build/site -c-1