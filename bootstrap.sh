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

_brew=/home/linuxbrew/.linuxbrew/bin/brew

_install_homebrew() {
	if command -v brew >/dev/null 2>&1; then
		echo "Homebrew is already installed. Skipping installation."
	else
		echo "Homebrew is not installed. Proceeding with installation."

		NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		echo "eval \"\$($_brew shellenv)\"" >>~/.bashrc
		echo "eval \"\$($_brew shellenv)\"" >>~/.brewenv
		eval "$($_brew shellenv)"
	fi
}

_install_build_tools
_install_homebrew

brew install mise stow fzf ripgrep fd lazygit starship zoxide

# ensure that there is no conflicting zshrc
rm ~/.zshrc

cd ~/.dotfiles
stow nvim starship zsh

mv ~/.zshrc ~/._zshrc
mv ~/.brewenv ~/.zshrc
cat ~/._zshrc >>~/.zshrc

mise install node@latest
mise use -g node@latest
