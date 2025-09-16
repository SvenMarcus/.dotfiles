# Resolve symlinks portably
_resolve_path() {
	if command -v realpath >/dev/null 2>&1; then
		realpath "$1"
	elif command -v greadlink >/dev/null 2>&1; then
		greadlink -f "$1"
	else
		readlink -f "$1"
	fi
}

dcup() {
	local workspace="${1:-$(pwd)}"

	devcontainer up --workspace-folder "$workspace" --remove-existing-container
}

# Always rebuild devcontainer with Neovim setup (features + mounts)
dcup-nvim() {
	local workspace="${1:-$(pwd)}"

	# Resolve symlinks for Neovim config and plugin cache
	local nvim_config=$(_resolve_path "$HOME/.config/nvim")
	local nvim_data=$(_resolve_path "$HOME/.local/share/nvim")

	echo "Workspace folder: $workspace"
	echo "Neovim Config: $nvim_config"
	echo "Neovim Data: $nvim_data"

	# Rebuild devcontainer with Neovim and Node features only
	devcontainer up --workspace-folder "$workspace" --remove-existing-container \
		--additional-features '{
      "ghcr.io/duduribeiro/devcontainer-features/neovim:1": {},
      "ghcr.io/devcontainers/features/node:1": {}
    }' \
		--mount "type=bind,source=$nvim_config,target=/home/dev-user/.config/nvim"

	# Install build tools, fzf, fd, ripgrep via package manager
	devcontainer exec --workspace-folder "$workspace" -- sh -c '
    if command -v apt >/dev/null 2>&1; then
      sudo apt update
      sudo apt install -y build-essential cmake
      mkdir -p ~/.local/bin
    elif command -v apk >/dev/null 2>&1; then
      sudo apk add --no-cache build-base cmake git
    else
      echo "Unsupported package manager. Please install fd, fzf, ripgrep, lazygit, and build tools manually."
    fi

    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    echo >> /home/dev-user/.bashrc
    echo eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)" >> /home/dev-user/.bashrc
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

    brew install fzf ripgrep fd lazygit
  '
}

# Exec a command inside the running devcontainer
dcexec() {
	local workspace="${1:-$(pwd)}"
	shift
	devcontainer exec --workspace-folder "$workspace" "$@"
}

# Drop into a shell inside the devcontainer
dcshell() {
	local workspace="${1:-$(pwd)}"
	devcontainer exec --workspace-folder "$workspace" zsh -l ||
		devcontainer exec --workspace-folder "$workspace" bash -l
}

# Run neovim inside the devcontainer directly
dcnvim() {
	local workspace="${1:-$(pwd)}"
	devcontainer exec --workspace-folder "$workspace" nvim "$@"
}

# Stop and clean up the devcontainer for the current project
dcdown() {
	local workspace="${1:-$(pwd)}"
	devcontainer down --workspace-folder "$workspace"
}
