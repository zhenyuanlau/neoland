VMS := h1 h2 h3
POETRY_CLI = $(shell command -v poetry 2> /dev/null)

.PHONY: setup deps.get pipx.install orb.vms $(VMS)

setup: deps.get pipx.install orb.vms

deps.get:
	brew bundle

pipx.install:
ifndef POETRY_CLI
	pipx install poetry
endif

orb.vms: $(VMS)

$(VMS):
	-orb create ubuntu $@ -c cloud-init/ubuntu.yml
