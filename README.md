# Dotfiles

These are my current dotfiles. You need Ansible 2 to install them.

For the first run, you'll need to use ansible-playbook

```bash
ansible-playbook -i ~/.playbooks/inventory.conf -c local ~/.playbooks/site.yml --ask-vault-pass
```

After the initial run, helper methods will be available:

```bash
ansible-run # Run as the current user
ansible-sudo # Run, asking for sudo password
```

### Peru
Peru is a dependency management tool. To run it, install `peru` via pip and
run `peru sync`

### Variables
All variables are provided via `rolename/defaults/main.yml`. These files are
GPG encrypted as well as using `ansible-vault`. Run `./bin/decrypt-defaults` to
decrypt them


# OS Specific requirements

### Arch Linux

* Install yaourt
* yaourt -S powerline-fonts-git

### yaourt packages

* powerline-fonts-git
* google-chrome
* libu2f-host
* slack-desktop
