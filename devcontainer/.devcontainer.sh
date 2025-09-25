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
		--dotfiles-repository "https://github.com/SvenMarcus/.dotfiles" \
		--dotfiles-target-path "~/.dotfiles" \
		--mount "type=volume,source=devcontainer_homebrew,target=/home/linuxbrew/"
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
