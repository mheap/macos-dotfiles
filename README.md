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
ansible-arch # Run on a local Arch machine
```

### Peru
Peru is a dependency management tool. To run it, install `peru` via pip and
run `peru sync`

### Variables
All variables are provided via `rolename/defaults/main.yml`. These files are
GPG encrypted as well as using `ansible-vault`. Run `./bin/decrypt` to
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
ansible-playbook -i inventory/arch-local -c local site.yml --ask-vault-pass --ask-become-pass
```

### OSX

Install OSXFuse - https://github.com/osxfuse/osxfuse/releases

```
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install gpg ansible python3
pip3 intall peru
peru sync
ansible-playbook -i inventory/osx-local -c local playbook-osx.yml --ask-vault-pass --ask-become-pass
```

Fix ntfs mounting (see https://gist.github.com/Coeur/86a18b646a3b78930cf3)


