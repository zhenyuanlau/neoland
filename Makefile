VMS := h1 h2 h3
POETRY_CMD := $(shell command -v poetry 2> /dev/null)

.PHONY: setup deps.get pipx.install ansible.galaxy cloud.init vms $(VMS) inventory

default: deps.get vms inventory ai.infra

deps.get: brew.bundle pipx.install ansible.galaxy

vms: cloud.init multipass.vms

brew.bundle:
	@brew bundle

pipx.install:
ifndef POETRY_CMD
	@pipx install poetry
endif
	@poetry install --no-root

ansible.galaxy:
	@poetry run ansible-galaxy collection install community.docker --force

cloud.init:
	@poetry run ansible localhost -m template -a "src=cloud-init/ubuntu.yml.j2 dest=cloud-init/ubuntu.yml" -e "ssh_pub_key={{ lookup('file', '~/.ssh/id_rsa.pub')}}"

# multipass.vms: $(VMS)
orb.vms: $(VMS)

$(VMS):
	# -multipass launch docker -n $@ -c 2 -m 4G -d 40G --cloud-init cloud-init/ubuntu.yml
	-orb create ubuntu $@ -c cloud-init/ubuntu.yml

inventory:
	@multipass ls | awk 'NR>1 || /h[0-9]+/ {print $$1 " ansible_user=ai ansible_ssh_host=" $$3}' > inventories/hosts.ini

ai.infra:
	@poetry run ansible-playbook playbooks/site.yml
