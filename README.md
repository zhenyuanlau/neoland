# AI Infra

## Ansible

###  Ad-Hoc

Syntax: `ansible <pattern> -m <module_name> -a <arguments>`.

```shell
ansible all -m ping

ansible all -a "/bin/echo hello"
```

### Playbook

```shell
ansible-playbook -i production site.yml --tags ftp

ansible-galaxy init nodejs
```