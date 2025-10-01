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

_get_remote_workspace_folder() {
	local cid="$1"
	local local_workspace="$2"

	local ws_folder=$(docker inspect "$cid" --format '{{ .Config.WorkingDir }}')

	if [[ -z "$ws_folder" || "$ws_folder" == "null" ]]; then
		ws_folder="/workspaces/$(basename "$local_workspace")"
	fi

	echo "$ws_folder"
}

_guess_remote_user_from_json() {
	local workspace="$1"
	local dcjson="$workspace/.devcontainer/devcontainer.json"

	if [[ -f "$dcjson" ]]; then
		jq -r '.remoteUser // empty' "$dcjson"
	fi
}

_get_devcontainer_id() {
	docker ps --filter "label=devcontainer.local_folder=$(realpath ".")" --format "{{.ID}}"
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

	local remote_user=$(_guess_remote_user_from_json $workspace)
	[[ -z "$remote_user" ]] && remote_user="vscode"

	local home_path="/home/$remote_user"

	echo "Remote user: $remote_user"
	echo "Remote user home: $home_path"

	mkdir -p ~/.local/share/opencode/
	[[ ! -f "~/.local/share/opencode/auth.json" ]] && touch ~/.local/share/opencode/auth.json

	devcontainer up --workspace-folder "$workspace" --remove-existing-container \
		--dotfiles-repository "https://github.com/SvenMarcus/.dotfiles" \
		--dotfiles-target-path "~/.dotfiles" \
		--mount "type=volume,source=devcontainer_homebrew,target=/home/linuxbrew/" \
		--mount "type=bind,source=$HOME/.local/share/opencode,target=$home_path/.local/share/opencode" \
		--mount "type=bind,source=$HOME/.gitconfig,target=$home_path/.gitconfig" \
		--additional-features '{
	    "ghcr.io/duduribeiro/devcontainer-features/neovim:1":{}
	  }'
	# not mounting nvim data for now as we keep having issues with that
	# --mount "type=volume,source=devcontainer_nvim_share,target=$home_path/.local/share/nvim" \
	# --mount "type=volume,source=devcontainer_nvim_state,target=$home_path/.local/state/nvim" \
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
	# local workspace="${1:-$(pwd)}"
	# local cid=$(docker ps --filter "label=devcontainer.local_folder=$(realpath ".")" --format "{{.ID}}")
	#
	# if [ -z "$cid" ]; then
	# 	echo "❌ No devcontainer found for $workspace"
	# 	return 1
	# fi
	#
	# local remote_user=$(
	# 	docker inspect "$cid" \
	# 		--format '{{ index .Config.Labels "devcontainer.metadata" }}' |
	# 		jq -r '.[] | select(.remoteUser != null) | .remoteUser' | head -n1
	# )
	#
	# local workspace_folder=$(_get_remote_workspace_folder "$cid" "$workspace")
	# docker exec -u $remote_user -w $workspace_folder -it "$cid" zsh -i -c "nvim \"$@\""
	devcontainer exec --workspace-folder "$(pwd)" zsh -i -c "nvim"
}

# Stop and clean up the devcontainer for the current project
dcdown() {
	local workspace="${1:-$(pwd)}"
	devcontainer down --workspace-folder "$workspace"
}
