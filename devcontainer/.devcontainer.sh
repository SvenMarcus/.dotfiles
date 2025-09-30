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

	devcontainer up --workspace-folder "$workspace" --remove-existing-container \
		--dotfiles-repository "https://github.com/SvenMarcus/.dotfiles" \
		--dotfiles-target-path "~/.dotfiles" \
		--mount "type=volume,source=devcontainer_homebrew,target=/home/linuxbrew/" \
		--mount "type=volume,source=devcontainer_nvim_share,taget=~/.local/share/nvim" \
		--mount "type=volume,source=devcontainer_nvim_state,taget=~/.local/state/nvim" \
		--additional-features '{
	    "ghcr.io/duduribeiro/devcontainer-features/neovim:1":{}
	  }'
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
	local cid=$(docker ps --filter "label=devcontainer.local_folder=$(realpath ".")" --format "{{.ID}}")

	if [ -z "$cid" ]; then
		echo "❌ No devcontainer found for $workspace"
		return 1
	fi

	docker exec -it "$cid" zsh -i -c "nvim \"$@\""
}

# Stop and clean up the devcontainer for the current project
dcdown() {
	local workspace="${1:-$(pwd)}"
	devcontainer down --workspace-folder "$workspace"
}
