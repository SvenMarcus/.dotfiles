eval "$(starship init zsh)"
eval "$(mise activate zsh)"

source $HOME/.devcontainer.sh


# Created by `pipx` on 2023-03-17 15:08:28
export PATH="$PATH:/Users/marcus/.local/bin"

alias singularity="docker run --privileged --rm --platform=linux/amd64 --network=host -it -v $PWD:/data -w /data quay.io/singularity/singularity:v4.1.0"
alias lg="lazygit"

eval "$(zoxide init zsh)"

