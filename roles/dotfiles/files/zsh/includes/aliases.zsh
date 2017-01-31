# GLS comes from `brew install coreutils`
if $(gls &>/dev/null); then
 LS_COM="gls"
else
 LS_COM="ls"
fi


# Running Dotfiles
alias ansible-run='ansible-playbook -c local $@ --ask-vault-pass'
alias ansible-sudo='ansible-run -K'
alias ansible-arch='ansible-sudo -i ~/.playbooks/inventory/arch-local $@ ~/.playbooks/playbook-desktop.yml'
alias ansible-system='ansible-sudo --tags=dotfiles'
alias ansible-dotfiles='ansible-run --tags=dotfiles'
alias ansible-vim='ansible-run --tags=vim'

# Mounting/unmounting secure
SRC_DIR=/media
MOUNT_DIR=/media
USE_SUDO=""
if [[ "`uname`" == "Darwin" ]]; then
SRC_DIR=/Volumes
MOUNT_DIR=/Users/michael
fi

lock() {
    sudo umount $MOUNT_DIR/lockbox && echo "Locked"
}

unlock() {
    bindfs -n -p 0700 -u $(id -u) -g $(id -g) $SRC_DIR/DATASHUR $MOUNT_DIR/lockbox
    echo "Unlocked"
}

# Default options
alias ls='$LS_COM --color'

# Other useful aliases
if [[ "`uname`" == "Linux" ]]; then
alias open='xdg-open'
fi

# VPN management
v(){
    ps aux | grep "[v]pnc /etc/vpnc/vpn-ds-$1.conf" > /dev/null;
    if [ $? -eq 1 ]; then
        echo "Starting $1 VPN"
        sudo netctl stop vpn-ds-$1
        sudo netctl start vpn-ds-$1
    else
        echo "Stopping $1 VPN"
        sudo netctl stop vpn-ds-$1
    fi
}

vp() {
    v production
}

vs() {
    v staging
}

vo() {
    v openstack
}

# Aliases
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}

t() {
    cat ~/Dropbox/todo
}

et() {
    vim ~/Dropbox/todo
}

ts-mocha() {
    rm -rf coverage && node_modules/.bin/ts-node ./node_modules/istanbul/lib/cli.js cover -ext .ts node_modules/mocha/bin/_mocha "$@"
}
