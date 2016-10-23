# Dotfiles

These are my current dotfiles. You need Ansible >= 2.3 to install them.

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

```
cd .playbooks
./bin/decrypt-defaults
sudo pacman -S python2 git openssh binutils gcc pkg-config make fakeroot python2
git clone https://aur.archlinux.org/package-query.git
git clone https://aur.archlinux.org/yaourt.git
cd package-query && makepkg -si && cd ..
cd yaourt && makepkg -si && cd ..
yaourt -S ansible-git
sudo pip install peru
peru sync
ansible-playbook -i inventory.conf -c local site.yml --ask-vault-pass --ask-become-pass
```
