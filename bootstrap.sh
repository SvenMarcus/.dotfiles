_install_build_tools() {
	if command -v apt >/dev/null 2>&1; then
		sudo apt update
		sudo apt install -y build-essential cmake
		mkdir -p ~/.local/bin
	elif command -v apk >/dev/null 2>&1; then
		sudo apk add --no-cache build-base cmake git
	else
		echo "Unsupported package manager. Please install fd, fzf, ripgrep, lazygit, and build tools manually."
	fi
}

_brew="/home/linuxbrew/.linuxbrew/bin/brew"

_install_homebrew() {
	if command -v brew >/dev/null 2>&1; then
		echo "Homebrew is already installed. Skipping installation."
	else
		echo "Homebrew is not installed. Proceeding with installation."

		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	fi
}

_setup_brew_shellenv() {
	echo eval "$($_brew shellenv)" >>~/.zshrc
	eval "$($_brew shellenv)"
}

_install_build_tools
_install_homebrew

# we are using the full brew path here, because we fist need to install zsh before we can use it for the brew shellenv
$_brew install mise stow fzf ripgrep fd lazygit neovim starship zoxide zsh
cd ~/.dotfiles
stow nvim starship zsh

_setup_brew_shellenv

mise install node@latest
