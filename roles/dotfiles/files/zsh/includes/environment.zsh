setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode
setopt RM_STAR_WAIT         # Force the user to wait before `rm *`

# Named directories
setopt AUTO_NAME_DIRS
export oss="$HOME/development/oss"
export datasift="$HOME/development/datasift"
export cookbooks="$HOME/development/ds-cookbooks"

# Paths
# Add directories to $PATH if they exist
function add_to_path() { [[ -d $1 ]] && export PATH="$1:$PATH"; }

add_to_path "$HOME/development/golang/bin"
add_to_path "$HOME/.gem/ruby/2.2.0/bin"
add_to_path "$HOME/.composer/vendor/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"

# Development
export GOPATH=~/development/golang

# Editors
export EDITOR=vim
export VISUAL=vim
