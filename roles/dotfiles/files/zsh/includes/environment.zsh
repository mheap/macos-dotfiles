setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode
setopt RM_STAR_WAIT         # Force the user to wait before `rm *`

# Named directories
setopt AUTO_NAME_DIRS
setopt AUTOCD
export oss="$HOME/development/oss"
export d="$HOME/development/digime"
export dc="$HOME/development/digime-cookbooks"
export dtf="$HOME/development/digime-terraform"
export projects="$HOME/development/projects"

# Paths
# Add directories to $PATH if they exist
function add_to_path() { [[ -d $1 ]] && export PATH="$1:$PATH"; }

add_to_path "$HOME/development/golang/bin"
add_to_path "$HOME/.gem/ruby/2.3.0/bin"
add_to_path "$HOME/.composer/vendor/bin"
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/bin"

# Development
export GOPATH=~/development/golang

# Editors
export EDITOR=vim
export VISUAL=vim
