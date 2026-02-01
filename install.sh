#!/bin/bash
set -e

GITHUB_RAW="https://raw.githubusercontent.com/xkenneth/ken-tmux-setup/main"

echo "Ken's tmux setup installer"
echo "=========================="

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)  OS_TYPE="linux";;
    Darwin*) OS_TYPE="macos";;
    *)       echo "Unsupported OS: $OS"; exit 1;;
esac
echo "Detected OS: $OS_TYPE"

# Install tmux and dependencies
install_deps() {
    echo "Installing dependencies..."
    if [ "$OS_TYPE" = "macos" ]; then
        if ! command -v brew &>/dev/null; then
            echo "Homebrew not found. Please install it first: https://brew.sh"
            exit 1
        fi
        brew install tmux
    elif [ "$OS_TYPE" = "linux" ]; then
        if command -v apt-get &>/dev/null; then
            sudo apt-get update
            sudo apt-get install -y tmux xsel xclip
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y tmux xsel xclip
        elif command -v pacman &>/dev/null; then
            sudo pacman -S --noconfirm tmux xsel xclip
        else
            echo "Could not detect package manager. Please install tmux manually."
            exit 1
        fi
    fi
}

# Install Oh My Tmux
install_oh_my_tmux() {
    echo "Installing Oh My Tmux..."
    if [ -d "$HOME/.oh-my-tmux" ]; then
        echo "Oh My Tmux already installed, updating..."
        cd "$HOME/.oh-my-tmux" && git pull
        cd - >/dev/null
    else
        git clone https://github.com/gpakosz/.tmux.git "$HOME/.oh-my-tmux"
    fi

    # Symlink oh-my-tmux base config
    ln -sf "$HOME/.oh-my-tmux/.tmux.conf" "$HOME/.tmux.conf"
    echo "Symlinked Oh My Tmux config"
}

# Download and install config files
install_configs() {
    echo "Downloading config files..."

    # Backup existing .tmux.conf.local if it's a real file (not symlink)
    if [ -f "$HOME/.tmux.conf.local" ] && [ ! -L "$HOME/.tmux.conf.local" ]; then
        echo "Backing up existing .tmux.conf.local"
        mv "$HOME/.tmux.conf.local" "$HOME/.tmux.conf.local.backup.$(date +%s)"
    fi

    # Remove symlink if exists
    [ -L "$HOME/.tmux.conf.local" ] && rm "$HOME/.tmux.conf.local"

    # Download .tmux.conf.local (bypass CDN cache)
    curl -fsSL -H 'Cache-Control: no-cache' "$GITHUB_RAW/.tmux.conf.local" -o "$HOME/.tmux.conf.local"
    echo "Installed .tmux.conf.local"
}

# Add ~/.local/bin to PATH in shell config
add_to_path() {
    local shell_rc=""
    local path_line='export PATH="$HOME/.local/bin:$PATH"'

    # Determine shell config file
    if [ -n "$ZSH_VERSION" ] || [ "$SHELL" = "/bin/zsh" ] || [ "$SHELL" = "/usr/bin/zsh" ]; then
        shell_rc="$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ] || [ "$SHELL" = "/bin/bash" ] || [ "$SHELL" = "/usr/bin/bash" ]; then
        shell_rc="$HOME/.bashrc"
    fi

    # Also check for .bash_profile on macOS
    if [ "$OS_TYPE" = "macos" ] && [ -f "$HOME/.bash_profile" ] && [ ! -f "$HOME/.bashrc" ]; then
        shell_rc="$HOME/.bash_profile"
    fi

    if [ -z "$shell_rc" ]; then
        echo "Could not detect shell config file. Add this to your shell config manually:"
        echo "  $path_line"
        return
    fi

    # Check if already in config
    if grep -q '\.local/bin' "$shell_rc" 2>/dev/null; then
        echo "~/.local/bin already in $shell_rc"
    else
        echo "" >> "$shell_rc"
        echo "# Added by ken-tmux-setup" >> "$shell_rc"
        echo "$path_line" >> "$shell_rc"
        echo "Added ~/.local/bin to PATH in $shell_rc"
    fi
}

# Install helper scripts
install_scripts() {
    echo "Installing helper scripts..."
    mkdir -p "$HOME/.local/bin"

    # Download tmux-dev.sh (bypass CDN cache)
    curl -fsSL -H 'Cache-Control: no-cache' "$GITHUB_RAW/tmux-dev.sh" -o "$HOME/.local/bin/tmux-dev"
    chmod +x "$HOME/.local/bin/tmux-dev"
    echo "Installed tmux-dev to ~/.local/bin/tmux-dev"

    # Add to PATH if not already there
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        add_to_path
    fi
}

# Main
if ! command -v tmux &>/dev/null; then
    install_deps
else
    echo "tmux already installed: $(tmux -V)"
fi

install_oh_my_tmux
install_configs
install_scripts

echo ""
echo "Installation complete!"
echo ""
echo "Features enabled:"
echo "  - Mouse support (on by default)"
echo "  - Vi mode for copy/paste"
echo "  - Pane titles displayed"
echo "  - System clipboard integration"
echo ""
echo "Usage:"
echo "  tmux-dev [dir]  - Launch dev environment with multi-pane layout"
echo ""
echo "Reload tmux config: prefix + r"
echo "Toggle mouse: prefix + m"
