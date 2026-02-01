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

# Install helper scripts
install_scripts() {
    echo "Installing helper scripts..."
    mkdir -p "$HOME/.local/bin"

    # Download tmux-dev.sh (bypass CDN cache)
    curl -fsSL -H 'Cache-Control: no-cache' "$GITHUB_RAW/tmux-dev.sh" -o "$HOME/.local/bin/tmux-dev"
    chmod +x "$HOME/.local/bin/tmux-dev"
    echo "Installed tmux-dev to ~/.local/bin/tmux-dev"

    # Check if ~/.local/bin is in PATH
    if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
        echo ""
        echo "NOTE: Add ~/.local/bin to your PATH:"
        echo "  echo 'export PATH=\"\$HOME/.local/bin:\$PATH\"' >> ~/.bashrc"
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
echo "  - Session persistence (tmux-resurrect + continuum)"
echo "  - System clipboard integration"
echo ""
echo "Usage:"
echo "  tmux-dev [dir]  - Launch dev environment with multi-pane layout"
echo ""
echo "Reload tmux config: prefix + r"
echo "Toggle mouse: prefix + m"
